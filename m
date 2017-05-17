From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-ndd shipped by infiniband-diags and rdma-core
Date: Wed, 17 May 2017 10:20:14 +0200
Message-ID: <1495009214.3739.19.camel@profitbricks.com>
References: <1494335693.3752.1.camel@profitbricks.com>
         <20170509175406.GJ10073@mtr-leonro.local>
         <2807E5FD2F6FDA4886F6618EAC48510E67CAA0F6@CRSMSX101.amr.corp.intel.com>
         <2807E5FD2F6FDA4886F6618EAC48510E67CAB41D@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67CAB41D-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)'" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Dienstag, den 16.05.2017, 20:43 +0000 schrieb Weiny, Ira:
> One other thing I forgot to mention...
> 
> Infiniband-diags has a configure option to disable rdma-ndd.
> 
> 16:43:16 > ./configure --help | grep rdma
>   --enable-rdma-ndd build rdma-ndd (default=yes)
>   --with-rdma-service=name
>                           name of the RDMA service: "rdma" when using
>                           /etc/init.d/rdma to start RDMA services;
> "openibd"
>                           services [default=${default_rdma_service}]
> 
> Benjamin, would that be ok for you to continue your work?

Yes. We can use --disable-rdma-ndd and coordinate this infiniband-diags 
update with the introduction of rdma-core.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
