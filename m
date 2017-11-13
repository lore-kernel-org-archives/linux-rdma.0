From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Mon, 13 Nov 2017 22:56:44 +0530
Message-ID: <CANjDDBgiB4tFmyGeQwEk53Czs1iJzKLvF6mwSmOZeNm0cUo-8g@mail.gmail.com>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de> <20171113151437.GL18825@mtr-leonro.local>
 <f5e11706-5c7e-a79e-fcf3-4d3df5f35632@suse.de> <20171113163812.GN18825@mtr-leonro.local>
 <CANjDDBgqg_i53_pZW-ctiW2GUVc4nft4JQuHZLFEZYiJyzXdTQ@mail.gmail.com> <2ee14e55-2998-0dbf-6367-ed6d7915c291@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ee14e55-2998-0dbf-6367-ed6d7915c291-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Yeah,

Jason is asking for further amendments to the barrier mechanism we
have today in rdma-core. That can be handled in a separate patch
series.
For now this should be good to go unless Jason suggests otherwise.

On Mon, Nov 13, 2017 at 10:36 PM, Nicolas Morey-Chaisemartin
<NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org> wrote:
>
>
> Le 13/11/2017 =C3=A0 18:02, Devesh Sharma a =C3=A9crit :
>> Hi Nicolas,
>>
>> Please include following patch as well along with the one you have
>> listed already
>>
>> bnxt_re/lib: fix the memory barrier call during poll-cq
>> commit-id: f4e67f1027011a6f9081b6239b866f27f750f678
>>
>> -Regards
>> Devesh
>
> Hi,
>
> I saw some concern from Jason (didn't follow up the thread yet) about the=
 barrier (even though it was in master already).
> Did you come to an agreement on the current patch ?
> If yes, I'll add it to the list.
>
> Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
