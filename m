From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] cbuild: Add udev dependency to package list
 of SuSE Leap
Date: Mon, 6 Nov 2017 10:15:34 +0100
Message-ID: <c9ecd165-c670-c58b-6d7b-006140fc15af@suse.de>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-2-leon@kernel.org>
 <3a06c93f-aa0f-93fa-1b74-af6388051f89@suse.de>
 <20171102174220.GD16127@mtr-leonro.local>
 <b2493da4-396e-5d24-ffa5-2fcccb9ee85c@suse.de>
 <20171102183257.GI16127@mtr-leonro.local>
 <76d45899-f1ec-bbd1-e0dd-799e1fa4a400@dev.mellanox.co.il>
 <20171106020518.GC12187@ziepe.ca>
 <aae35c17-8135-9e4b-8ff8-f92558316f95@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aae35c17-8135-9e4b-8ff8-f92558316f95-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 06/11/2017 à 08:58, Alaa Hleihel a écrit :
>
> On 06/11/2017 4:05, Jason Gunthorpe wrote:
>> On Sun, Nov 05, 2017 at 10:13:57AM +0200, Alaa Hleihel wrote:
>>  
>>> -%if 0%{?suse_version} >= 1330
>>> -BuildRequires:? curl-mini
>>> -%endif
>> No idea what it would need curl to build, so the above seems right to me?
>>
>> Jason
> I also don't believe that curl is required for build. But, I think we should wait for Nicolas to comment before removing these lines.
>
> Regards,
> Alaa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

There is no direct dependency to curl but an indirect one that I don't remember.
This is required to avoid cyclic build dependency in our build system. (something like curl requires boost which requires rdma-core which requires curl through some dependencies)

I don't know why it's not available on download.opensuse.org... I'll check with the guy in charge and submit a patch if needed

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
