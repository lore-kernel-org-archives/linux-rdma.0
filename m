From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Mon, 13 Nov 2017 18:30:09 +0100
Message-ID: <9460d921-47ee-eb05-10fc-a9f09e53a1bf@suse.de>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de>
 <20171113151437.GL18825@mtr-leonro.local>
 <f5e11706-5c7e-a79e-fcf3-4d3df5f35632@suse.de>
 <20171113163812.GN18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113163812.GN18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 13/11/2017 à 17:38, Leon Romanovsky a écrit :
> On Mon, Nov 13, 2017 at 05:19:46PM +0100, Nicolas Morey-Chaisemartin wrote:
>> Added to the list.
>> Should we backport the changes done for travis validation ?
>> It doesn't impact the code per say but it'd be nice to have the same validation running in the stable branch.
> It depends on the easiest path: backport CI to stable, or teach main CI
> to run for stable too.
>
> Thanks

I've backported all the patches to run docker for centos and tumbleweed and it seems to work out of the box :)
https://travis-ci.org/nmorey/rdma-core/builds/301507907

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
