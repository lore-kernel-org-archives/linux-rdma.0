From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: "Virtual" ibnetdiscover command fails
Date: Wed, 06 Feb 2013 11:26:17 +0100
Message-ID: <51122FC9.50003@profitbricks.com>
References: <CAOoYFkFw-0WDYt6gQ-t0V6QaV8p7qraYrMbA-NxeiPVfUy2Bkg@mail.gmail.com> <201302052134.17622.jackm@dev.mellanox.co.il> <CAOoYFkF_nE4JNg2ooKXHyO2jqQkjOyczqmBHSehZHtS2tBEFLQ@mail.gmail.com> <511220EA.4020607@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511220EA.4020607-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06.02.2013 10:22, Or Gerlitz wrote:
> On 06/02/2013 11:17, Mathis GAVILLON wrote:
>> Ok. But what is it possible to do with Infiniband VFs if QP0 is not
>> available ?
> 
> EVERYTHING, e.g run IPoIB, iSER, RDS, MPI, etc, etc - except for what
> requires QP0, such as running SM or issuing SMPs for
> discovery/diagnostics purposes

But SRP isn't provided with SR-IOV I've heared. Is it just a matter of
software or is it a matter of firmware/hardware?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
