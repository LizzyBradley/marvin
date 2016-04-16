// Please choose a data type to compile
#define DATATYPE 0
#include "marvin.hpp"

using namespace marvin;
using namespace std;

bool examine_flag(const char* flag, int &i, int &argc, char **argv) {
    if (0==strcmp(argv[i], flag)) {
	argc--;
	for (int j = i; j < argc; j++)
            argv[j] = argv[j+1];

	argv[argc+1] = 0;
	i--;

	return true;
    }
    return false;
}

int main(int argc, char **argv){

    if (argc < 3 || argc >10){
        cout<<"Usage:"<<endl;
        cout<<argv[0]<<" train network.json [model1.marvin[,model2.marvin,...]] [snapshot_iteration]"<<endl;
        cout<<"       example: "<<argv[0]<<" train examples/mnist/lenet.json"<<endl;
        cout<<argv[0]<<" test network.json model1.marvin[,model2.marvin,...] response_name1[,name2,...] file_name1.tensor[,name2.tensor,...] [save_every_n_iterations]"<<endl;
        cout<<"       example: "<<argv[0]<<" test examples/mnist/lenet.json examples/mnist/lenet.marvin ip1,conv2 examples/mnist/ip1.tensor,examples/mnist/conv2.tensor"<<endl;
        cout<<argv[0]<<" activate network.json model1.marvin[,model2.marvin,...] response_name_data response_name1[,name2,...] response1_channels[,response2_channels,...] file_prefix topK maxIterations"<<endl;
        cout<<"       example: "<<argv[0]<<" activate examples/mnist/lenet.json examples/mnist/lenet.marvin data conv1,conv2 [0,1,2],[0,1,2,3,4,5] examples/mnist/filters_ 100 20"<<endl;
        return 0;

    }

    cout<< "====================================================================================================================================="<<endl;
    cout<< ">> Hello, World! This is Marvin. I am at a rough estimate thirty billion times more intelligent than you. Let me give you an example."<<endl;
    cout<< "====================================================================================================================================="<<endl;

    if(0==strcmp(argv[1], "train")){
	bool benchmark_mode = false;  // Turn on timing benchmarks
	bool hier_mode      = false;  // Turn on hierarchical summation
	bool verbose_mode   = false;  // Turn on verbose, debug printing
	bool uva_mode       = false;  // Turn on alt. memory storage

	// Identify command-line flags
	for (int i = 2; i < argc; i++) {
	    if (!benchmark_mode)
		benchmark_mode = examine_flag("-bench", i, argc, argv);
	    if (!hier_mode)
		hier_mode = examine_flag("-hier", i, argc, argv);
	    if (!verbose_mode)
		verbose_mode = examine_flag("-v", i, argc, argv);
	    if (!uva_mode)
		uva_mode = examine_flag("-uva", i, argc, argv);
	}

	map<const char*, bool> params;
  	params["benchmark_mode"] = benchmark_mode;
	params["hier_mode"]      = hier_mode;
	params["verbose_mode"]   = verbose_mode;
	params["uva_mode"]       = uva_mode;

        Solver solver(argv[2], params);
        solver.Malloc(Training);
        solver.randInit();
        
        if (argc==3){       
            solver.train();
        }else if (argc==4 || argc==5){

            vector<string> models = getStringVector(argv[3]);
            for (int m=0;m<models.size();++m)   solver.loadWeights(models[m],true);

            if (argc==4){
                solver.train();
            }else{
                solver.train(atoi(argv[4]));
            }
        }else FatalError(__LINE__);
        
        solver.saveWeights(solver.path + ".marvin");
        
    }else if(0==strcmp(argv[1], "test")){

        Net net(argv[2]);
        net.Malloc(Testing);

        vector<string> models = getStringVector(argv[3]);
        for (int m=0;m<models.size();++m)   net.loadWeights(models[m]);

        if (argc>=6){
            int itersPerSave = 0;
            if (argc==7){
                itersPerSave = atoi(argv[6]);
            }
            net.test(getStringVector(argv[4]), getStringVector(argv[5]), itersPerSave);
        }else if (argc==4){
            net.test();
        }else FatalError(__LINE__);

    }else if(0==strcmp(argv[1], "activate")){

        Net net(argv[2]);
        net.Malloc(Testing);
        
        vector<string> models = getStringVector(argv[3]);
        for (int m=0;m<models.size();++m)   net.loadWeights(models[m]);

        net.getTopActivations(argv[4], getStringVector(argv[5]), getIntVectorVector(argv[6]), argv[7], atoi(argv[8]), atoi(argv[9]));
    }

    return 0;
}
