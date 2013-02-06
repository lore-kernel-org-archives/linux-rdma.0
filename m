From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: "Virtual" ibnetdiscover command fails
Date: Wed, 6 Feb 2013 12:20:45 +0200
Message-ID: <51122E7D.3030607@mellanox.com>
References: <CAOoYFkFw-0WDYt6gQ-t0V6QaV8p7qraYrMbA-NxeiPVfUy2Bkg@mail.gmail.com> <201302052134.17622.jackm@dev.mellanox.co.il> <CAOoYFkF_nE4JNg2ooKXHyO2jqQkjOyczqmBHSehZHtS2tBEFLQ@mail.gmail.com> <511220EA.4020607@mellanox.com> <CAOoYFkHArx4_eH90ehaPupCkXyRjO4KzZ7CGkXkqGm3kSWJfKA@mail.gmail.com> <CAOoYFkEWkxMOsU2VejmYXXcpQY3+LxJCHpBswh6L6fTJgwoe1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOoYFkEWkxMOsU2VejmYXXcpQY3+LxJCHpBswh6L6fTJgwoe1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/02/2013 12:04, Mathis GAVILLON wrote:
> Just a last question : is that possible VFs lid to be different from PF one ?

NO, we've implemented a "shared port" model, so all functions on the 
same IB port use the same lid, each function has its own
virtual GUID though.

Or.


>
> Thanks
>
> 2013/2/6 Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> EVERYTHING, e.g run IPoIB, iSER, RDS, MPI, etc, etc - except for what
>>> requires QP0, such as running SM or issuing SMPs for discovery/diagnostics
>>> purposes
>> Ok. I just begin with Infiniband technologie so I don't know
>> everything about this yet.
>>
>> Thanks
>>
>> Mathis

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
