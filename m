From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [PATCH v4 10/10] IB/mlx5: Simplify completion into a wait_event
Date: Thu, 3 Nov 2016 11:33:04 +0530
Message-ID: <CAHv-k_97o9eYODRgkWa-NodXPWf+hJ5M9+hHrkm=rn9p6cY9Jw@mail.gmail.com>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
 <1477551554-30349-11-git-send-email-binoy.jayan@linaro.org> <8ceb7dbf-d242-1427-199a-b6ec82876f23@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8ceb7dbf-d242-1427-199a-b6ec82876f23@grimberg.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

On 31 October 2016 at 02:47, Sagi Grimberg <sagi@grimberg.me> wrote:

> How is this simpler?

It is simpler in the sense that it is a light weight primitive and that only
one thread waits on the event here. In our case since 'umr_context.done'
is an "on stack" variable, and has only one thread waiting on that event,
no race conditions occur. So, we do not need completions here which
are usually used to provide a race-free but easy-to-use solution involving
multiple threads waiting on an event.

>>  enum ib_wc_status {
>> +       IB_WC_STATUS_NONE = -1,
>>         IB_WC_SUCCESS,
>>         IB_WC_LOC_LEN_ERR,
>>         IB_WC_LOC_QP_OP_ERR,
>>
>
> Huh? Where did this bogus status came from? IMHO, this is polluting
> the verbs interface for no good reason at all, sorry.

context->status is initialized to -1 in the following code, so I just thought of
replacing it with a name.

static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
 {
        context->cqe.done = mlx5_ib_umr_done;
-       context->status = -1;
-       init_completion(&context->done);
+       context->status = IB_WC_STATUS_NONE;
+       init_waitqueue_head(&context->wq);
 }

Thanks,
Binoy
