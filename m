From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 07/24] ibtrs: client: sysfs interface functions
Date: Tue, 6 Feb 2018 13:28:29 +0100
Message-ID: <CAJrWOzAt+czFLFUMg2B01hahEiTVby6WFkXyn2D5_uQ3OKuw5A@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-8-roman.penyaev@profitbricks.com> <1e874694-b30e-d957-6b48-edefe8e41c9a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1e874694-b30e-d957-6b48-edefe8e41c9a@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 5, 2018 at 12:20 PM, Sagi Grimberg <sagi@grimberg.me> wrote:
> Hi Roman,
>
>
>> This is the sysfs interface to IBTRS sessions on client side:
>>
>>    /sys/kernel/ibtrs_client/<SESS-NAME>/
>>      *** IBTRS session created by ibtrs_clt_open() API call
>>      |
>>      |- max_reconnect_attempts
>>      |  *** number of reconnect attempts for session
>>      |
>>      |- add_path
>>      |  *** adds another connection path into IBTRS session
>>      |
>>      |- paths/<DEST-IP>/
>>         *** established paths to server in a session
>>         |
>>         |- disconnect
>>         |  *** disconnect path
>>         |
>>         |- reconnect
>>         |  *** reconnect path
>>         |
>>         |- remove_path
>>         |  *** remove current path
>>         |
>>         |- state
>>         |  *** retrieve current path state
>>         |
>>         |- stats/
>>            *** current path statistics
>>            |
>>           |- cpu_migration
>>           |- rdma
>>           |- rdma_lat
>>           |- reconnects
>>           |- reset_all
>>           |- sg_entries
>>           |- wc_completions
>>
>> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
>> Signed-off-by: Danil Kipnis <danil.kipnis@profitbricks.com>
>> Cc: Jack Wang <jinpu.wang@profitbricks.com>
>
>
> I think stats usually belong in debugfs.

I will change that.

--
Roman
