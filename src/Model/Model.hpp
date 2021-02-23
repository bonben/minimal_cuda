#ifndef MODEL_HPP_
#define MODEL_HPP_

#include <vector>

class Model
{
protected:
    const int n_particles;

public:
    Model();

    virtual ~Model() = default;

    virtual void step() = 0;
};

#endif // MODEL_HPP
