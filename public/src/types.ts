export interface Fact {
  id?: number;
  theme_id?: number;
  key: string;
  value: string;
}

export interface Tag {
  id?: number;
  value: string;
}

export interface Publication {
  id?: number;
  user_id?: number;
  experience_id?: number;
  authors: string;
  title: string;
  venue: string;
  date: string;
  link?: string;
}

export interface Experience {
  [key: string]: any;
  id?: number;
  title: string;
  company: string;
  startdate: string;
  enddate?: string;
  summary: string;
  tags: Tag[];
  publications: Publication[];
}

export interface Theme {
  id?: number;
  user_id?: number;
  name: string;
  tags: string[];
}

export interface Portfolio {
  name: string;
  facts: Fact[];
  professionalExperiences: Experience[];
  education: Experience[];
  publications: Publication[];
  themes: Theme[];
  email: string;
  location: string;
  phone: string;
  tags?: Tag[];
}

export interface Question {
  id?: number;
  user_id?: number;
  question: string;
  type: "text" | "textarea" | "skills";
  required: boolean;
}

export interface Message {
  id?: number;
  question_id?: number;
  sender: any;
  value: string;
}

export interface OpportunityTag {
  id?: number;
  selected: boolean;
  name: string;
}

export interface Opportunity {
  id?: number;
  messages: Message[];
  tags: OpportunityTag[];
}
