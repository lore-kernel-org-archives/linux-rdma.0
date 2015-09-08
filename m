From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 4/7] devcg: Added rdma resource tracker object per task
Date: Tue, 8 Sep 2015 13:56:20 +0530
Message-ID: <CAG53R5UZs1Xz45KmTpfLtvnWnr0Xta+NNQ4OUeBMQtosihq37Q@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<1441658303-18081-5-git-send-email-pandit.parav@gmail.com>
	<55EE76C7.1000804@mellanox.com>
	<CAG53R5VwLnDUjpOwaD_gZMkRBjyT1Wg_sSPw2gAg9oJkqdn3dQ@mail.gmail.com>
	<55EE9B58.70908@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <55EE9B58.70908@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 8, 2015 at 1:54 PM, Haggai Eran <haggaie@mellanox.com> wrote:
> On 08/09/2015 10:04, Parav Pandit wrote:
>> On Tue, Sep 8, 2015 at 11:18 AM, Haggai Eran <haggaie@mellanox.com> wrote:
>>> On 07/09/2015 23:38, Parav Pandit wrote:
>>>> @@ -2676,7 +2686,7 @@ static inline int thread_group_empty(struct task_struct *p)
>>>>   * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
>>>>   * subscriptions and synchronises with wait4().  Also used in procfs.  Also
>>>>   * pins the final release of task.io_context.  Also protects ->cpuset and
>>>> - * ->cgroup.subsys[]. And ->vfork_done.
>>>> + * ->cgroup.subsys[]. Also projtects ->vfork_done and ->rdma_res_counter.
>>> s/projtects/protects/
>>>>   *
>>>>   * Nests both inside and outside of read_lock(&tasklist_lock).
>>>>   * It must not be nested with write_lock_irq(&tasklist_lock),
>>>
>>
>> Hi Haggai Eran,
>> Did you miss to put comments or I missed something?
>
> Yes, I wrote "s/projtects/protects/" to tell you that you have a typo in
> your comment. You should change the word "projtects" to "protects".
>
> Haggai
>
ah. ok. Right. Will correct it.
