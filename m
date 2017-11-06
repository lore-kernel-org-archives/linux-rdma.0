From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] cbuild: Add udev dependency to package
 list of SuSE Leap
Date: Sun, 5 Nov 2017 19:05:18 -0700
Message-ID: <20171106020518.GC12187@ziepe.ca>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-2-leon@kernel.org>
 <3a06c93f-aa0f-93fa-1b74-af6388051f89@suse.de>
 <20171102174220.GD16127@mtr-leonro.local>
 <b2493da4-396e-5d24-ffa5-2fcccb9ee85c@suse.de>
 <20171102183257.GI16127@mtr-leonro.local>
 <76d45899-f1ec-bbd1-e0dd-799e1fa4a400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <76d45899-f1ec-bbd1-e0dd-799e1fa4a400-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 05, 2017 at 10:13:57AM +0200, Alaa Hleihel wrote:
 
> -%if 0%{?suse_version} >= 1330
> -BuildRequires:? curl-mini
> -%endif

No idea what it would need curl to build, so the above seems right to me?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
