From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core]bnxt_re bug fix
Date: Mon, 11 Sep 2017 19:19:58 +0530
Message-ID: <CANjDDBi=_-qf8ZjkJVtPzsV+Bzpe2a3nZFkRgcXGp4FNGnh04g@mail.gmail.com>
References: <1504893687-6101-1-git-send-email-devesh.sharma@broadcom.com> <20170911130034.GJ3405@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911130034.GJ3405-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Leon.

On Mon, Sep 11, 2017 at 6:30 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Sep 08, 2017 at 02:01:26PM -0400, Devesh Sharma wrote:
>> A quick fix to add new PCI IDs to libbnxt_re
>>
>> Devesh Sharma (1):
>>   bnxt_re:update and sort pci device id table
>
> Thanks, I reworked the commit message and applied.
> Please take a look.
>
>>
>>  providers/bnxt_re/main.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
