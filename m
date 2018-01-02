From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net 0/2] IB/ipoib: ip link support
Date: Tue, 2 Jan 2018 11:15:52 +0200
Message-ID: <CAJ3xEMj2f-Eg4eGmuv0o5d25SytX07T5sCshYVV49whw+Wax1w@mail.gmail.com>
References: <1514718983-466-1-git-send-email-denisd@mellanox.com>
 <CAJ3xEMiVHc=E7=uKJ4cRRRDxjNDRKQ17=NxnYsEeXNe6-RUvvQ@mail.gmail.com>
 <CAJ3xEMiRGpwp8NVdjm9ozTswer_YRP3uvjV5bUFg7cQ7Jh97vw@mail.gmail.com> <CAAk-MO-J3-9zy8vZ2pFs33Nbo22zLm1gW2qqCm2EejE=S8xxuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAAk-MO-J3-9zy8vZ2pFs33Nbo22zLm1gW2qqCm2EejE=S8xxuA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Erez Shitrit <erezsh@dev.mellanox.co.il>
Cc: Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, David Miller <davem@davemloft.net>, RDMA mailing list <linux-rdma@vger.kernel.org>, Linux Netdev List <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 2, 2018 at 10:44 AM, Erez Shitrit <erezsh@dev.mellanox.co.il> wrote:
> On Tue, Jan 2, 2018 at 9:29 AM, Or Gerlitz <gerlitz.or@gmail.com> wrote:
>> On Sun, Dec 31, 2017 at 2:28 PM, Or Gerlitz <gerlitz.or@gmail.com> wrote:
>>> On Sun, Dec 31, 2017 at 1:16 PM, Denis Drozdov <denisd@mellanox.com> wrote:
>>>> IP link was broken due to the changes in IPoIB for the rdma_netdev
>>>> support after commit cd565b4b51e5
>>>> ("IB/IPoIB: Support acceleration options callbacks").
>>>
>>> you are approaching stable kernels, right? lets make sure dave is okay
>>> to pick the net (touching dev.c etc) patch to stable even if the
>>> offending patch didn't change anything there.
>>
>> Erez, Denis
>>
>> The offending commit went in 4.12-rc1, so the fix should be getting
>> a while back. RU sure you need the net/core patch to fix that up or
>> we can come up with ipoib only patch?
>
> The preferred approach was to have 2 patches one for ipoib and one for core/net.
> So, we can't with patch to ipoib only.

going with your approach, you must sure that the 1st patch is also
backportable all the way back to 4.12

Or.

> Denis, the author of the patches is on new-year vacation, he will
> close all the gaps as soon as he will be back.
