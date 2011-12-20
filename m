From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Tue, 20 Dec 2011 09:54:53 +0100
Message-ID: <CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A@mail.gmail.com>
References: <4EEA0577.5030304@profitbricks.com>
	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>
	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>
	<4EF02E10.4070501@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EF02E10.4070501-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2011/12/20 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
>
> Beep, I'd like to better/understand the problem before looking on your
> struggle for solution...
> I understand that your Debian system runs kernel 3.0 - however, you didn't
> say what version of the iscsi initiator utils is provided with that distro
> nor what were the problems to make it work/well with iser, could you
> elaborate on that?
>
> Or.
>

Ah, O.K. - I wrote that on the open-iscsi list. Debian Squeeze (in
general 2.6.32 based) comes with open-iscsi 2.0.871.3-2squeeze1. We've
used that version together with the in-tree mainline kernel 3.0 OFA
kernel modules and Debian Squeeze OFED-1.4 user-space. But there were
lots of iSER connection aborts (and even log-outs) after only 5s
connection loss instead of 120s
node.session.timeo.replacement_timeout. The many connection losses
where also caused by the missing of a suitable OFED.

After installation of the OFA kernel modules (without open-iscsi
modules) from OFED-1.5.4 the kernel had oopses in ib_iser. Therefore,
the suitable open-iscsi code had to be found (in OFED). And due to the
fact that it didn't support 3.0 kernels it also had to be ported.
There where many ABI and API changes in mainline open-iscsi kernel
code between 2.6.30 and 3.0.

I've fixed the following kernel API changes in the open-iscsi code
from OFA kernel source from OFED-1.5.4:
- kfifo API >= 2.6.33
- scsi_host API >= 2.6.33
- scsi_host API >= 2.6.37

Before that I've added the code and compilation of libiscsi_tcp from 2.6.30.

After stress testing the storage on a test machine with that fixed
OFED + iSER all other machines on that IB switch had IB connection
losses. So, we decided to roll out OFED-1.5.4 with fixed open-iscsi
code to all machines in our data center. And this works very well,
now. General network performance also doubled up.

Btw.: We need such a new kernel because of some cool virtualization,
cgroups and performance features.

I wrote the mail in this mailing list in order to show that open-iscsi
in OFED-1.5.4 isn't suitable for 3.0 kernel, that libiscsi_tcp is
missing and that we at ProfitBricks have a good test case with our
IaaS Cloud Computing.

Btw.: I like the proposed approach for new OFED releases. Version
checks in the code between kernel and user-space (like DRBD does)
would be great.

Cheers,

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
