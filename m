From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags 2/6] ibstat.c: fix
 buffer-not-null-terminated
Date: Wed, 12 Jun 2013 23:21:47 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0207E8B2@CRSMSX101.amr.corp.intel.com>
References: <51B87DD4.9040005@dev.mellanox.co.il>
 <20130612141948.c4760f2856d2e4435be2b0a7@intel.com>
 <51B8F03C.8010004@dev.mellanox.co.il> <51B8F0E9.90508@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0207E124@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0207E124-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> Subject: RE: [PATCH infiniband-diags 2/6] ibstat.c: fix buffer-not-null-
> terminated
> 
> > >
> > > I think the change is to quiet a Coverity detected error but Dan is
> > > the definitive source for this change.
> 
> I think we should remove the dead code and that should fix Coverity.  I
> thought it detected dead code.  I wonder if I missed something?

That is not dead code.  I misread where the break jumps to.
	
However, the code is redundant and there is a bug.[*]

16:16:51 > ibstat -l
mlx4_0
mlx4_1
16:17:57 > ibstat -l mlx4_1
mlx4_0

The intent was to copy argv[0] into names[0] and set n=1.  But that is not happening...
	
Ira

[*] not that the above is really a valid use case.
	
> 
> Ira
> 
> > >
> > > -- Hal
> > >
> > >> Ira
> > >>
> > >>>  		n = 1;
> > >>>  	}
> > >>>
> > >>> --
> > >>> 1.7.8.2
> > >>>
> > >>
> > >>
> > >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
