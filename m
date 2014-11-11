From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 0/9] Peer-Direct support
Date: Tue, 11 Nov 2014 10:42:53 +0200
Message-ID: <CAJ3xEMhgR3Aoce-gbSf3rXv=Zz+O3gMfQN1UJCRpH9HDNWm30g@mail.gmail.com>
References: <A9EAB01D3BD8F64D8C9802C8BDC0C7F29ACE888B@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A9EAB01D3BD8F64D8C9802C8BDC0C7F29ACE888B-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Coffman, Jerrie L" <jerrie.l.coffman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 28, 2014 at 8:29 PM, Coffman, Jerrie L
<jerrie.l.coffman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> [...] to obtain the source for review.  Steps are as follows:
> Download and extract the latest OFED-3.12-1 release (rc3 in this case) from OpenFabrics.org
> cd OFED-3.12-1-rc3/SRPMS/
> rpm2cpio compat-rdma-3.12-1.1.g9594cac.src.rpm | cpio -vid
> tar xzf compat-rdma-3.12.tgz
> cd compat-rdma-3.12
> ofed_scripts/ofed_patch.sh --with-patchdir=tech-preview/xeon-phi/
> The code of interest is located in the IB proxy server located in drivers/infiniband/ibp/drv directory [...]

I bet busy upstream kernel maintainers/reviewers would not go that
far... can you make it easily reviewable? that is, either send as
patches to this list or much easier put the relevant piece in public
git tree (github?)

> Possible upstreaming plans for CCL direct are still being discussed.  Since the CCL direct code depends on a low level MIC driver called SCIF, we would have to wait until the group at Intel that owns that driver gets it upstream before attempting to upstream CCL direct [..]

I do see these three config directives set in my upstream clone, and
checking reveals they were
added in 3.13

# Intel MIC Bus Driver
CONFIG_INTEL_MIC_BUS=m
# Intel MIC Host Driver
CONFIG_INTEL_MIC_HOST=m
# Intel MIC Card Driver
CONFIG_INTEL_MIC_CARD=m

Can you point to the missing elements in the chart present @ this LWN
post http://lwn.net/Articles/564795/

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
