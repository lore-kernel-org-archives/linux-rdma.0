From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Trouble enabling iSER for ConnectX-4 Lx
Date: Thu, 27 Oct 2016 11:48:15 +0300
Message-ID: <ba970fe1-52cd-9f8d-c48d-5eac76b5bfa2@grimberg.me>
References: <CAANLjFr_we+33Nen-NYp1xQPzQ-wbR=GL4LBkEZb9azMUN-_=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFr_we+33Nen-NYp1xQPzQ-wbR=GL4LBkEZb9azMUN-_=Q@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Robert,

AFAIK, MLNX_OFED does includes isert only for specific distros.

This is probably a compat issue between stock isert and MLNX
provided RDMA stack.

Any specific reason not to use upstream (or stock 4.4.27) kernel?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
