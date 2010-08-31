From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: OFED 1.5.2: libibumad.so version bump
Date: Tue, 31 Aug 2010 12:49:15 -0700
Message-ID: <20100831124915.ac4dc1bd.weiny2@llnl.gov>
References: <4C7CCB01.909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7CCB01.909-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OpenFabricsEWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Mark A. Grondona" <mgrondona-i2BcT+NCU+M@public.gmane.org>, "Moody, Adam T." <moody20-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 31 Aug 2010 02:27:29 -0700
Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi all,
> 
> In order to support RoCEE, a while ago I've added
> a new field to umad, thus introduced an ABI change.
> 
> There already was a discussion on the linux-rdma list,
> but due to the proximity of the upcoming OFED 1.5.2
> release these concerns were raised again.
> 
> So my question is, other that *general* concerns about
> changing ABI, is anybody aware of the *actual* problem
> that will be caused by this? Any customer/3rd party
> solution that would be affected by this?

Because our MVAPICH depends on umad, libibumad.so.1 to be exact.[*]  These ABI
changes (to v2 and v3) would have forced our users to recompile their codes.
We are maintaining the old ABI here until our next major release of CHAOS[#]
to prevent this.

I think the thing to remember is that many people are using Open Fabrics
software, but are _not_ using "OFED".  What is tested with OFED is not the
only thing which might be using these libraries.  Our version of MVAPICH is a
good example.

I am certainly not the expert in this area and I know that many people have
tried to make this point in the past, but I will say it here again.  Each of
these Open Fabrics packages _must_ be maintained to stand on their own.
Roland did this a long time ago with ibverbs.

I think now is a good time to start discussing breaking up the "management" git
tree so that these libraries can live on their own.  I will write a separate
email regarding this.

Ira

[*] We are looking into removing the dependency.
[#] Shameless plug: http://code.google.com/p/chaos-release/wiki/CHAOS_Description

> 
> -- Yevgeny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
