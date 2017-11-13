From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Mon, 13 Nov 2017 22:32:30 +0530
Message-ID: <CANjDDBgqg_i53_pZW-ctiW2GUVc4nft4JQuHZLFEZYiJyzXdTQ@mail.gmail.com>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de> <20171113151437.GL18825@mtr-leonro.local>
 <f5e11706-5c7e-a79e-fcf3-4d3df5f35632@suse.de> <20171113163812.GN18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113163812.GN18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Nicolas,

Please include following patch as well along with the one you have
listed already

bnxt_re/lib: fix the memory barrier call during poll-cq
commit-id: f4e67f1027011a6f9081b6239b866f27f750f678

-Regards
Devesh

On Mon, Nov 13, 2017 at 10:08 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Nov 13, 2017 at 05:19:46PM +0100, Nicolas Morey-Chaisemartin wrot=
e:
>>
>>
>> Le 13/11/2017 =C3=A0 16:14, Leon Romanovsky a =C3=A9crit :
>> > On Mon, Nov 13, 2017 at 04:02:26PM +0100, Nicolas Morey-Chaisemartin w=
rote:
>> >> Hi all,
>> >>
>> >> After looking into the ML, here are the candidates for the stable-v15=
 branch.
>> >> Can the authors please confirm that they should be applied there ?
>> >>
>> >> Please let me know if I missed any.
>> > In addition to the your list, I would like to see the following patche=
s too:
>> > commit dbf7bd2151815a12428caef6874149523c0bda8e
>> > Author: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> > Date:   Wed Oct 25 12:04:53 2017 +0300
>> >
>> >     verbs: Fix declaration of C++ include file in C-block
>> >
>> > commit 6a74285158a146f23cbf8a804fd9de32df0d5ed2
>> > Author: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> > Date:   Mon Oct 9 10:56:21 2017 +0300
>> >
>> >     verbs: Fix C++ compilation break
>> >
>> > commit 983f80191923c082324295ea68ac91d34daaa4c8
>> > Author: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
>> > Date:   Tue Sep 26 16:05:11 2017 +0200
>> >
>> >     verbs: fix compilation error with ICC
>> >
>> > commit bf03566e0aa976afc5dfbf917296280e9fa55bb8
>> > Author: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> > Date:   Mon Oct 2 04:17:09 2017 +0800
>> >
>> >     hns: Fix create QP structure layout
>> >
>> >
>> > Thanks
>> >
>> >
>>
>> Added to the list.
>> Should we backport the changes done for travis validation ?
>> It doesn't impact the code per say but it'd be nice to have the same val=
idation running in the stable branch.
>
> It depends on the easiest path: backport CI to stable, or teach main CI
> to run for stable too.
>
> Thanks
>
>>
>> Nicolas
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
