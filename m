From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Fri, 17 Nov 2017 07:54:28 +0100
Message-ID: <1319a1f9-062a-751b-52ee-247ec1779513@suse.de>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de>
 <20171113151437.GL18825@mtr-leonro.local>
 <f5e11706-5c7e-a79e-fcf3-4d3df5f35632@suse.de>
 <20171113163812.GN18825@mtr-leonro.local>
 <9460d921-47ee-eb05-10fc-a9f09e53a1bf@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B617AF6F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54347E5A035A054EAE9D05927FB467F9B617AF6F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org" <stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Le 16/11/2017 à 22:57, Davis, Arlin R a écrit :
>> I've backported all the patches to run docker for centos and tumbleweed and
>> it seems to work out of the box :)
>> https://travis-ci.org/nmorey/rdma-core/builds/301507907
>>
> Are we ready for our first rdma-core stable-branch release? All fixes needed for OFED are now in stable-v15 so we are ready to wrap up the OFED 4.8-1 release.
>
> Arlin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The fix patches are all there.
I'd like to add the abi checks to the branch as soon as they are merged to master.
I've a branch ready to push changes to the buildlib/redhat/suse dir for validation in Travis.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
