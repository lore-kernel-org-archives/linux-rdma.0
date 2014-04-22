From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Tue, 22 Apr 2014 19:01:37 +0300
Message-ID: <53569261.9010805@mellanox.com>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org> <CAJZOPZJfdaZ7QzgffzY9Ps-1aUCU+q_dSrj4XfekyfxNa-k+hg@mail.gmail.com> <alpine.DEB.2.10.1404211605390.29907@gentwo.org> <CAJZOPZ+FwPc3OSVyvk0i4=gX-x0zf_+M8zL1_t9HWmEKi5397Q@mail.gmail.com> <alpine.DEB.2.10.1404211926050.31858@gentwo.org> <alpine.DEB.2.10.1404220844430.4876@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1404220844430.4876-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 22/04/2014 16:48, Christoph Lameter wrote:
> Note that I am pretty unhappy about Mellanox right now. 8 year old patches
> that have never been refreshed? If I submit patchsets then I will post
> these things regularly until they are accepted. You need to have a patch
> queue or a git tree with up to date patches that contains all the patches
> you intend to merge.

Chritoph, again I can hear your Pain and Frustration (BTW the patch is 
from 2008 so only six years old...), when patches are repeatedly 
ignored, there's no much point in reposting them again and again. We are 
making sure that large patche sets are posted in a public git tree, for 
example the T10 signature patches were on the floor for 5-6 months and 
eventually went into 3.15 and during that hang time, we have put them in 
public git tree, I will make sure we do it right away for the ODP 
patches and other user space patches (RoCE UD and Flow-steering) that 
were posted here and still not accepted.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
