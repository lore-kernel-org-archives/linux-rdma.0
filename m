From: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] cbuild: Properly create tarball for SuSE
Date: Sun, 5 Nov 2017 10:19:50 +0200
Message-ID: <e92e2213-d08a-b3ae-5d34-ff0b331f83c2@dev.mellanox.co.il>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-3-leon@kernel.org> <20171102171738.GP18874@ziepe.ca>
 <20171102175735.GE16127@mtr-leonro.local> <20171102181217.GS18874@ziepe.ca>
 <20171102182526.GG16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102182526.GG16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 02/11/2017 20:25, Leon Romanovsky wrote:
> On Thu, Nov 02, 2017 at 12:12:17PM -0600, Jason Gunthorpe wrote:
>> On Thu, Nov 02, 2017 at 07:57:35PM +0200, Leon Romanovsky wrote:
>>
>>>> Are you running cbuild as root or something? What is the docker
>>>> command the script uses?
>>> For me too, it doesn't reproduce, most probably Alaa run it as a root.
>> Okay lets instead ban running cbuild as root?
> I'm fine with that, but lets wait till Sunday before dropping this patch,
> so Alaa will have chance to respond.
>
> Thanks

Hi,

Correct, I saw this issue when I tested the build using 'root' user.
I'll drop this patch.

Regards,
Alaa


>> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
