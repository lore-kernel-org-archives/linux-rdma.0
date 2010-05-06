From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [ewg] ibcheckerrors "Port All FAILED" reported
Date: Wed, 5 May 2010 18:57:23 -0700
Message-ID: <20100505185723.a5f5bd55.weiny2@llnl.gov>
References: <382A478CAD40FA4FB46605CF81FE39F45685DEAD@orsmsx507.amr.corp.intel.com>
	<20100505180943.a9bbb74e.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100505180943.a9bbb74e.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet@me>
List-Id: linux-rdma@vger.kernel.org

Nevermind, I am wrong about the below.

However, there is an option to "emulate" the all ports when it is not supported.

That is a way to fix this I believe.
Ira

On Wed, 5 May 2010 18:09:43 -0700
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> Interesting...
> 
> I have a switch which does this as well.  Tracing through the scripts shows
> that the perfquery command is failing like this.
> 
> 14:29:03 > ./perfquery 40 255
> ./perfquery: iberror: failed: AllPortSelect not supported
> 
> It seems there is an issue with the CapabilityMask value...
> 
> 14:43:32 > ./perfquery 40 255
> cap_mask 0x400  <=== my debug output
> ./perfquery: iberror: failed: AllPortSelect not supported
> 
> 14:43:38 > ./saquery CPI 40
> SA ClassPortInfo:
> ...
>                 Capability mask..........0x2602
> ...
> 
> Those don't match because...  perfquery has a bug...
> 
> perfquery is issuing a PMA query when it should be issuing a SA query.  It
> just so happens that on some switches the result of that PMA query indicates
> AllPortSelect is available.  Patch to follow.
> 
> Ira
> 
> 
> On Wed, 5 May 2010 13:47:54 -0700
> "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > 
> > Hi guys,
> > 
> > When I run ibcheckerrors on my Mellanox switch,
> > it is reporting that Port all FAILED. 
> > 
> > From what I can tell, the switch is working fine and
> > I think that this is a bogus error from the program.
> > 
> > If this is indeed not a real problem, can the diagnostic
> > be fixed to not report this as an error ?
> > 
> > 
> > ibcheckerrors -nocolor -v -t 100
> > 
> > # Checking Switch: nodeguid 0x0002c902004046a0
> > Node check lid 7: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port all: FAILED   <------------
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 2: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 3: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 7: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 8: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 9: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 10: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 17: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 18: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 20: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 25: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 26: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 27: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 28: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 34: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 35: OK
> > Error check on lid 7 (Infiniscale-IV Mellanox Technologies) port 36: OK
> > 
> >  Checking Ca: nodeguid 0x0002c9030002628a
> > Node check lid 14: OK
> > Error check on lid 14 (cstnh-2 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c90300025e0a
> > Node check lid 12: OK
> > Error check on lid 12 (cstnh-3 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c9030002615e
> > Node check lid 15: OK
> > Error check on lid 15 (cstnh-4 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c9030008e442
> > Node check lid 11: OK
> > Error check on lid 11 (cstnh-8 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c9030008e44e
> > Node check lid 8: OK
> > Error check on lid 8 (cstnh-11 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c9030008e3e6
> > Node check lid 2: OK
> > Error check on lid 2 (cstnh-13 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c9030008e44a
> > Node check lid 18: OK
> > Error check on lid 18 (cstnh-9 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c90300044fb4
> > Node check lid 13: OK
> > Error check on lid 13 (cstnh-7 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c90300044fbc
> > Node check lid 10: OK
> > Error check on lid 10 (cstnh-1 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c9030008e3ee
> > Node check lid 9: OK
> > Error check on lid 9 (cstnh-10 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c9030008e446
> > Node check lid 4: OK
> > Error check on lid 4 (cstnh-12 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c9030008e22e
> > Node check lid 1: OK
> > Error check on lid 1 (cstnh-14 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c9030008e43e
> > Node check lid 19: OK
> > Error check on lid 19 (cstnh-15 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0090270002000345
> > Node check lid 6: OK
> > Error check on lid 6 (cstnh-5 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0090270002000335
> > Node check lid 5: OK
> > Error check on lid 5 (cstnh-6 HCA-1) port 1: OK
> > 
> > # Checking Ca: nodeguid 0x0002c90300028238
> > Node check lid 3: OK
> > Error check on lid 3 (cst-linux HCA-1) port 1: OK
> > 
> > ## Summary: 17 nodes checked, 0 bad nodes found
> > ##          32 ports checked, 0 ports have errors beyond threshold
> > _______________________________________________
> > ewg mailing list
> > ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> > http://**lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
> > 
> 
> 
> -- 
> Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> 


-- 
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
