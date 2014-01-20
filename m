From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Mon, 20 Jan 2014 15:56:14 +0200
Message-ID: <CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
	<CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
	<52CD1C68.4050406@mellanox.com>
	<1389645171.5567.459.camel@haakon3.risingtidesystems.com>
	<1389820541.5567.543.camel@haakon3.risingtidesystems.com>
	<CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
	<1389906852.5567.668.camel@haakon3.risingtidesystems.com>
	<CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>
	<1390102949.5567.749.camel@haakon3.risingtidesystems.com>
	<52DBB4F1.4020400@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52DBB4F1.4020400-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 19, 2014 at 1:20 PM, sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Thanks Nic,  let me elaborate on this,
>
> It is true that T10-PI aims for end-to-end data-integrity, the verbs API offer HW offload for protection
> information processing which is VERY expensive for CPU computation (CRC verify for each block). T10-PI
> is intended to be offloaded, both on the backend devices which supports this feature and for fabric
> transports (such as Qlogic/Emulex FC drivers), Verbs API just adds RDMA to the game...
>
> T10-PI specifies protection information scheme in a way that over the wire each protection interval is
> followed by 8 bytes of data-integrity (interleaved). In the memory on the other hand, the data and
> protection block-guards may lie in separated buffers (for example that is the preferred approach in block
> and SCSI layers).
>
> Newly introduced REG_SIG_MR work request allows to (fast) register a "signature" memory key which
> incorporates the protection method and pattern used:
> 1. Where is the data? (data sge)
> 2. Where is the protection block-guards? (protection sge)
> 3. What are the signature attributes? (T10-PI method, crc/reftag/apptag seeds, verify mask, memory pattern, wire pattern)
> When doing the actual data-transfer the HCA will enforce T10-PI scheme (See my cover-letter for a more detailed explanation).
>
> If you take a look in SCSI implementation you will see that SCSI signals the transport of protection attributes in
> scsi_cmnd (prot SG-list, protection type, guard type, protection operation). Verbs API allows full offload of all
> T10-PI operations:
> 1. INSERT - HCA computes/generates data-integrity block-guards and writes them according to the specified
>     pattern (interleaved with the data or in a separated buffer).
> 2. STRIP (and VERIFY) - HCA verifies incoming data-integrity block-guards and strip them from the data stream.
> 3. PASS (and VERIFY) - HCA verifies incoming data-integrity block-guards and passes them forward according to
>     the specified pattern (interleaved/separated).
>
> In addition, Verbs API can be easily extended to support other data-integrity methods (XOR-32, CRC-32, etc...)
> so that an application interested in data-integrity has signature verbs in its tool-box. This is why we use "Signature"
> notation and refer to T10-PI as a specific signature method.
>
> Hope this helps,

Hi Roland,

So with Nic's && Sagi's answers @ hand, were your questions resolved?

Also, Nic put the V4 patches in a branch on his tree for 0-day testing
and we had one hit from Dan Carpenter which Sagi addressed with
incremental fix he sent you.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
