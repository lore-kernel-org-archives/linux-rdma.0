From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: SoftRoCE V1
Date: Thu, 31 Dec 2015 11:04:40 +0200
Message-ID: <CANvqgxArCoXV7tbq79Gofj5-PzjpYv3seACLMxxZcoXYLD6Kvw@mail.gmail.com>
References: <CAEnvTt1KBHXYzjfHKmWkQtUs1J-ABhY_maQibR5LE9t+F25sYQ@mail.gmail.com>
	<5684EBDD.8070204@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5684EBDD.8070204-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Wenda Ni <wonda.ni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 31, 2015 at 10:48 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 29/12/2015 18:01, Wenda Ni wrote:
>> Hi experts,
>>
>> We have several Mellanox RoCE V1 NIC cards, and would like to try
>> communicating with SoftRoCE V1.
>>
>> We are using branch rxe-3.0 from https://github.com/SoftRoCE/rxe-dev
>> according to the Soft-RoCE README Rev 1.0 issued from Mellanox last
>> year.
>>
>>
>> Testing using pingpong examples from libibverbs (hardware RoCE <->
>> SoftRoCE) already shows a bug in Ethernet CRC generation. We expect
>> further bugs along the way.
>>
>> So we would like to know for SoftRoCE V1, are we using the latest
>> branch? Also, is it still tied to SLES11 SP3 OS?
> Kamal can correct me if I'm wrong, but I think the updated branch is rxe_submission-v2.
> However it doesn't support RoCE v1, only RoCE v2.
>

Correct, We support only RoCEv2 in the latest version of Soft-RoCE.

>> There are very few documentations we can find, so we hope this is the
>> right place to ask such questions.
> I can't think of a better place.
>
Agree.

> Regards,
> Haggai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Kamal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
