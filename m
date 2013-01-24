From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Error message when trying to use Infiniband virtual functions in
 virtual machine
Date: Thu, 24 Jan 2013 16:41:17 +0200
Message-ID: <CAJZOPZJ5mqbAwRx+UCGtNmLkvq_DsHF6y+dGNT9w_XKRKT=9QA@mail.gmail.com>
References: <CAOoYFkGrsWKGaFcNAQQnkks2Ku6O8xkPk=8BGQfRR74QhRU=VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOoYFkGrsWKGaFcNAQQnkks2Ku6O8xkPk=8BGQfRR74QhRU=VA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 23, 2013 at 5:29 PM, Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I'm working on a project in which I try to virtualize Infiniband. I use ConnectX3 Infiniband cards with FW 2.9.1200.
> I've installed a Fedora 18 OS with 3.8.0rc2 recompiled kernel. I use KVM 1.2 to run virtual machines.

Your firmware version is a bit old... if you can upgrade to the latest
GA on the Mellanox site (2.11.0500) would be good,

So what version of  qemu is installed on the distro you use? Are you
able to work over a ConnectX VF if probed
to the host? e.g use num_vfs=3 probe_vf=1 and see how the related mlx4
device (e.g mlx4_1) is functioning.

Also would be of help if you probe mlx4_core on both VM and host with
debug_level=1


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
