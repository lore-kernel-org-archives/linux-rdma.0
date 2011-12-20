From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Tue, 20 Dec 2011 13:01:10 +0200
Message-ID: <4EF06AF6.6080901@mellanox.com>
References: <4EEA0577.5030304@profitbricks.com> <CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com> <CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com> <4EF02E10.4070501@mellanox.com> <CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sebastian Riemer wrote:
> Debian Squeeze (in general 2.6.32 based) comes with open-iscsi 
> 2.0.871.3-2squeeze1. We've used that version together with the in-tree 
> mainline kernel 3.0 OFA kernel modules and Debian Squeeze OFED-1.4 
> user-space. But there were lots of iSER connection aborts (and even 
> log-outs) after only 5s connection loss instead of 120s 
> node.session.timeo.replacement_timeout. 
> Btw.: We need such a new kernel because of some cool virtualization,
> cgroups and performance features.
>

Beep(2), so your system has distro which is based on kernel 2.6.32 and 
iscsi initiator tools version 2.0.871 and per your needs, you've booted 
it with kernel 3.0 .

At this point should you have stop and make sure that this combo works, 
iscsi wise (simpler to test iscsi/tcp... no need in rdma knowledge), did 
you do this validation?

If this combo isn't working, you have to update the iscsi tools to a 
version which supports your kernel.

If this combo is working iscsi/tcp wise but not ib_iser wise, its seems 
to be a bug, and I'd be happy to help with finding the root cause, etc.

But this way or another, OFA isn't an iscsi tools factory, nor have 
anyone that can/want to support iscsi tools, we (folks from the rdma 
vendors community that deal with iscsi) are working with the upstream 
iscsi maintainer to address iscsi issues. The fact that OFA ships iscsi 
code except for ib_iser/cxgb4i/etc modules is a bug, BTW, I'll act to 
change that.


Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
