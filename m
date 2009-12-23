From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: OpenFabrics server is not responding
Date: Wed, 23 Dec 2009 18:58:19 +0200
Message-ID: <4B324C2B.7090303@dev.mellanox.co.il>
References: <2ED289D4E09FBD4D92D911E869B97FDD0222E943@mtlexch01.mtl.com> <382A478CAD40FA4FB46605CF81FE39F44F4BFC09@orsmsx507.amr.corp.intel.com> <2ED289D4E09FBD4D92D911E869B97FDD0222EB1A@mtlexch01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD0222EB1A-ia22CT07NJfiMCgWhms8HQC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, becker-2Ww08eqqtp6fRvmTrFJqzg@public.gmane.org, Bill Boas <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Jeffrey Scott <jeff-PQF7zMLV7HqjP/IhtLckvQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Tziporet Koren wrote:
> Vlad 
> Can you explain what you saw with other eth that are responding?
> 
> Tziporet


There is a problem with primary network interface of the OFA server (eth0 69.55.231.195).
Other three virtual interfaces work well and can be used for ssh (eth0:1 69.55.231.178, eth0:2 69.55.231.179, eth0:3 69.55.231.180).
So, bugzilla, wiki and svn web pages are available.

Regards,
Vladimir


> 
> -----Original Message-----
> From: Woodruff, Robert J [mailto:robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
> Sent: Wednesday, December 23, 2009 6:01 PM
> To: Tziporet Koren; Jeff Squyres; becker-2Ww08eqqtp6fRvmTrFJqzg@public.gmane.org; Bill Boas
> Cc: 'Jeffrey Scott'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: OpenFabrics server is not responding
> 
> Tziporet wrote,
> 
>> Bill - do you know who is the administrator that can fix this
>> We cannot access git and also web site and ewg mailing list does not
>> work
> 
> I cannot access it either. Does anyone know where it is physically
> located ?
> 
> woody
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
