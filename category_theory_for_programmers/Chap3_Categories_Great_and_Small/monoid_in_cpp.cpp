template<class T>
struct mempty;

template<class T>
T mappend(T, T) = delete;

template<class M>
concept Monoid = requires (M m){
    {mempty<M>::value()} -> std::same_as<M>;
    {mappend(m, m)} -> std::same_as<M>; 
};

template<>
struct mempty<std::string>{
    static std::string value() {return "";}
};

template<>
std::string mappend(std::string s1, std::string s2){
    return s1 + s2;
}