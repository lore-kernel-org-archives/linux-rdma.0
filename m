From: Andy Grover <agrover@redhat.com>
Subject: Re: ib_srpt and mellanox mthca device
Date: Thu, 12 Apr 2012 15:01:30 -0700
Message-ID: <4F8750BA.5030201@redhat.com>
References: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru> <CAL1RGDWNqMdQGrXbh2gj==_KvVRF1mUQw2D3NqEhjvuq2q2+6Q@mail.gmail.com> <97cccba5ba7ddc74e87b0791050fa755@omrb.pnpi.spb.ru> <CAL1RGDVbqOQP+AH4f9cs+mEngXVTOy7r7gRjJ=SU_rMmvCg3Qg@mail.gmail.com> <fa3a67e9423946c0bbd23abb3f60921a@omrb.pnpi.spb.ru> <CAL1RGDVn1Roo-KaZW_r_WAQudbEZ2+mXD2RqNS68Rg=UBTRe7Q@mail.gmail.com> <806c99edea592c69d0aa9073bae2a3b9@omrb.pnpi.spb.ru> <CAL1RGDXT1gshgxA+c9M==zxarKnjKZtcy4dROtOnKVmc9+u9HQ@mail.gmail.com> <2f4564980ae4cdafdc456a8e41b4ab04@omrb.pnpi.spb.ru> <CAL1RGDVh=n5rEB5GqmPaDvuNAKRkoVEro9LYr785zQpz7xR0vg@mail.gmail.com> <CAL1RGDXFVTD88ZF9rWoaDpOU7PuzdPcF7PSP4Ac6icgD=FPQLQ@mail.gmail.com> <41b9ab2a9c7e7a58c7e7a5b41bf1d9e8@omrb.pnpi.spb.ru> <CAL1RGDVjhpzSDUvkpdkG8u2YPwAWmt_szUw=wb3j3=gsb-iW-g@mail.gmai
 l.com> <4F87423D.8010104@redhat.com> <7d60e33d04e8dbae38f7cbf79a830801@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <7d60e33d04e8dbae38f7cbf79a830801@omrb.pnpi.spb.ru>
Sender: target-devel-owner@vger.kernel.org
To: Alexey Shvetsov <alexxy@gentoo.org>
Cc: Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 04/12/2012 02:18 PM, Alexey Shvetsov wrote:
>>>> Also another question. I still cannot create target with targetcli
>>>> nor with
>>>> configfs. It alays said that wwn is invalid and seems cannot

>> I also have no experience as yet using srpt, but see this post, it may
>> help use targetcli with it? Although if you also are having trouble via
>> configfs directly, then perhaps not.
>>
>> http://permalink.gmane.org/gmane.linux.scsi.target.devel/1513

> Well this were exactly this issue. Can someone commit fix to rtslib
> git?

I've applied this fix to rtslib-fb[1] but haven't seen it picked up
upstream yet.

> PS i have patch with gentoo init.d for lio-utils

rtslib-fb doesn't need lio-utils, to me this is a major selling point :)

Regards -- Andy

[1] https://github.com/agrover/rtslib-fb
