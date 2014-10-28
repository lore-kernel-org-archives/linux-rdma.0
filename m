From: "Coffman, Jerrie L" <jerrie.l.coffman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 0/9] Peer-Direct support
Date: Tue, 28 Oct 2014 18:29:25 +0000
Message-ID: <A9EAB01D3BD8F64D8C9802C8BDC0C7F29ACE888B@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Mon, Oct 27, 2014 at 2:25 PM, Yishai Hadas <yishaih@xxxxxxxxxxxx> =
wrote:
>
> Intel people pointed that CCL Direct for Intel Xeon Phi uses this API=
=2E=A0See=A0http://www.spinics.net/lists/linux-rdma/msg21605.html=A0.
> We are=A0checking with Intel >whether the relevant stuff can be share=
d for some=A0early review.

Intel Xeon Phi CCL direct is included as a technology preview in OFED-3=
=2E12-1.   The source contains another usage example for peer direct.  =
However, it is conditionally compiled in only for the Mellanox OFED rel=
ease, not the OpenFabrics release since the OpenFabrics does not have t=
he peer direct api (we define and use context-based ib_umem mapping rou=
tines instead).

Because CCL direct is a technology preview, it must be explicitly enabl=
ed with patches applied to the OFED-3.12-1 release.  Typically this is =
done during installation, but it can be done manually to obtain the sou=
rce for review.  Steps are as follows:

Download and extract the latest OFED-3.12-1 release (rc3 in this case) =
from OpenFabrics.org
cd OFED-3.12-1-rc3/SRPMS/
rpm2cpio compat-rdma-3.12-1.1.g9594cac.src.rpm | cpio -vid
tar xzf compat-rdma-3.12.tgz
cd compat-rdma-3.12
ofed_scripts/ofed_patch.sh --with-patchdir=3Dtech-preview/xeon-phi/

The code of interest is located in the IB proxy server located in drive=
rs/infiniband/ibp/drv directory.  Most of the peer direct code is withi=
n the MOFED ifdefs, however there are some changes due to other differe=
nces in Mellanox OFED.

Possible upstreaming plans for CCL direct are still being discussed.  S=
ince the CCL direct code depends on a low level MIC driver called SCIF,=
 we would have to wait until the group at Intel that owns that driver g=
ets it upstream before attempting to upstream CCL direct.  Currently th=
e timing of such upstreaming is still TBD.

-jerrie


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
