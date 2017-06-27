From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] ib_isert: prevent NULL pointer dereference in
 isert_login_recv_done()
Date: Tue, 27 Jun 2017 10:03:48 +0300
Message-ID: <980ca339-6a9d-31cb-7ffa-5de22d25e084@grimberg.me>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
 <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
 <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
 <20170622223757.GC28955@Dell>
 <1498435084.26123.66.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1498435084.26123.66.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrea Righi <righi.andrea@gmail.com>
Cc: Robert LeBlanc <robert@leblancnet.us>, Sean Jenkins <sean@betterservers.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

> Hi Andrea & Robert,

Hi Andrea, Robert, Nic and Co

>>>>> We have hit this four times today. Any ideas?
>>>>>
>>>>> [  169.382113] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>>>> [  169.382152] IP: [<ffffffffa051e968>] isert_login_recv_done+0x28/0x170 [ib_isert]
>>
>> So, we spent more time to track down this bug.
>>
>> It seems that at login time an error is happening, not sure exactly what
>> kind of error, but isert_connect_error() is called and isert_conn->cm_id
>> is set to NULL.
>>
>> Later, isert_login_recv_done() is trying to access
>> isert_conn->cm_id->device and we get the NULL pointer dereference.
>>
>> Following there's the patch that we have applied to track down this
>> problem.
>>
>> And this is what we see in dmesg with this patch applied:
>>
>>   [  658.633188] isert: isert_connect_error: conn ffff887f2209c000 error
>>   [  658.633226] isert: isert_login_recv_done: login with broken rdma_cm_id
>>
>> As we can see isert_connect_error() is called before isert_login_recv_done
>> and at that point isert_conn->cm_id is NULL.
>>
>> Obviously simply checking if the pointer is NULL, returning and ignoring
>> the error in isert_login_recv_done() is not the best fix ever and I'm
>> not sure if I'm breaking something else doing so (even if with this
>> patch the kernel doesn't crash and I've not seen any problem so far).
>>
>> Maybe a better way is to tear down the whole connection when this
>> particular case is happening? Suggestions?

That is an accurate analysis of what is going on, good job!

> So I assume isert_cma_handler() -> isert_connect_error() getting called
> to clear isert_conn->cm_id before connection established, and
> subsequently isert_conn->login_req_buf->rx_cqe.done() ->
> isert_login_recv_done() still getting invoked after connection failure
> is new RDMA API behavior..

That is correct, but its not really a new behavior, and absolutely
not introduced by the new RDMA API. We will _always_ see the
completion of _all_ recv wrs posted on the qp (given that we assigned
a ->done handler), this is a FLUSH error completion, we just don't
get to verify that because we deref NULL before.

The issue here, as you indicated was the assumption that dereferencing
the connection cm_id is always safe, which is not true since:

commit 4a579da2586bd3b79b025947ea24ede2bbfede62
Author: Sagi Grimberg <sagig@mellanox.com>
Date:   Sun Mar 29 15:52:04 2015 +0300

     iser-target: Fix possible deadlock in RDMA_CM connection error

     Before we reach to connection established we may get an
     error event. In this case the core won't teardown this
     connection (never established it), so we take care of freeing
     it ourselves.

     Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
     Cc: <stable@vger.kernel.org> # v3.10+
     Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

As I see it, we have a direct reference to the isert_device from
isert_conn which is the one-liner fix that we actually need (like
we do in isert_rdma_read_done, isert_rdma_write_done),  guess we
also need it in isert_login_send_done, isert_send_done (although
it can't really happen, but better safe and consistent than sorry).

> @@ -1452,7 +1452,7 @@
>   isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>   {
>   	struct isert_conn *isert_conn = wc->qp->qp_context;
> -	struct ib_device *ib_dev = isert_conn->cm_id->device;
> +	struct ib_device *ib_dev = isert_conn->device->ib_device;
>   
>   	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>   		isert_print_wc(wc, "login recv");

That's the one...
