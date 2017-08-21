From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] cbuild: use rpmspec for macro replacement
Date: Mon, 21 Aug 2017 09:52:57 +0200
Message-ID: <a17d1a6e-653a-0c8e-4b1b-d5ef2bf6d9b2@suse.de>
References: <27366048-d80f-3711-c6cd-93c87809650e@suse.de>
 <8ad0438f-b4a5-aec9-1e44-a9c9dc1ca17b@suse.de>
 <20170808230459.GF29372@obsidianresearch.com>
 <b3993b0c-0b9d-a917-cbf8-22f68c1d2a97@suse.de>
 <20170809155532.GC15586@obsidianresearch.com>
 <f42a6eaa-79f9-1063-b58a-08da363d09e7@suse.de>
 <20170809201932.GA7363@obsidianresearch.com>
 <5c4de783-ce62-2b8d-78aa-ee2f181fe719@suse.de>
 <20170809211536.GA10191@obsidianresearch.com>
 <20170813063706.GQ24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813063706.GQ24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Le 13/08/2017 à 08:37, Leon Romanovsky a écrit :
> On Wed, Aug 09, 2017 at 03:15:36PM -0600, Jason Gunthorpe wrote:
>> On Wed, Aug 09, 2017 at 11:08:34PM +0200, Nicolas Morey-Chaisemartin wrote:
>>
>>>> And drop a symlink to fix it up.
>>
>>> Yes this should work. It feels a little bit dirty to have a tarball
>>> name with unreplaced macro but it's a temporay state so I can live
>>> with this :)
>>
>> It is a bit strange, but this trivially delegates parsing the .tar.xx
>> to git archive which understands all the formats..
>>
>> Here is the patches, should I send them?
>>
>> https://github.com/jgunthorpe/rdma-plumbing/tree/cbuild
> 
> ????
> 
> Thanks
> 

Sorry for the late reply, was out of the office.
Yes your patches look good to me.

Thanks !

Nicolas

(Resent as previous one got dropped by majordomo due to HTML)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJZmpFZAAoJEIAb3bglmI9kIxYH/3hfV0ep7UxlpU7uMay2OUAh
X1V9rwikyMoTkI9qDDmVDpBL0WpUYVSSkAZio00a24I2HUVa4+ZIj6d27EYZkRru
oFloEkfH+aER/KvVkfWjE8SYOzS31ed6cgDRlqqjEncehobYR630Q3g/zfRpml+V
aoJtMakrHrZBAcnqD2XVxieaD4KOjx4IaewrKrV+hLxLuw6UjZHtbaKAD/HHajWs
I1xUQTHaIMHO6Su982+pTDyY0zlcK2MtzsPK2gcxuyiGn3oHAd9k6xpfsxXiWa5M
6LV60V/O/6QXDu/CAok/DP+E+zg0RgoHoftVnkGkS4zR3b0r1RZDUuxb8XWloL0=
=0XFR
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
