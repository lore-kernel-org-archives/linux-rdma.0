From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: "Virtual" ibnetdiscover command fails
Date: Wed, 06 Feb 2013 11:40:43 +0100
Message-ID: <5112332B.6090200@profitbricks.com>
References: <CAOoYFkFw-0WDYt6gQ-t0V6QaV8p7qraYrMbA-NxeiPVfUy2Bkg@mail.gmail.com> <201302052134.17622.jackm@dev.mellanox.co.il> <CAOoYFkF_nE4JNg2ooKXHyO2jqQkjOyczqmBHSehZHtS2tBEFLQ@mail.gmail.com> <511220EA.4020607@mellanox.com> <CAOoYFkHArx4_eH90ehaPupCkXyRjO4KzZ7CGkXkqGm3kSWJfKA@mail.gmail.com> <CAOoYFkEWkxMOsU2VejmYXXcpQY3+LxJCHpBswh6L6fTJgwoe1A@mail.gmail.com> <51122E7D.3030607@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51122E7D.3030607-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06.02.2013 11:20, Or Gerlitz wrote:
> On 06/02/2013 12:04, Mathis GAVILLON wrote:
>> Just a last question : is that possible VFs lid to be different from
>> PF one ?
> 
> NO, we've implemented a "shared port" model, so all functions on the
> same IB port use the same lid, each function has its own
> virtual GUID though.

So if I don't use the unmaintained srptools to get the SRP connection
strings but instead send them directly to the initiator to connect to
the SRP target, then also SRP should be possible with the virtual GUID.
Am I right?

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
