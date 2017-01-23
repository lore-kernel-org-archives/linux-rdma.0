From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Target core task management function handling rework
Date: Mon, 23 Jan 2017 16:15:17 -0700
Message-ID: <CAANLjFqFAbKwiqQGZcmPF_DOCxFe-DPHoqCeJNtATBYxCNGyhw@mail.gmail.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
 <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me> <1485210745.2825.15.camel@sandisk.com>
 <1903e7a0-ab80-6e63-5c56-49d649789556@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1903e7a0-ab80-6e63-5c56-49d649789556@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Yeah, I'll checkout this branch and try it.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Mon, Jan 23, 2017 at 3:43 PM, Sagi Grimberg <sagi@grimberg.me> wrote:
>
>>> Bart, I recall you had a patch at some point to periodically print
>>> out the hanging session commands in target_wait_for_sess_cmds(), do we
>>> want to get it in? I think we can all benefit from it.
>>
>>
>> (+target-devel)
>>
>> Hello Sagi,
>
>
> Hey Bart,
>
>>
>> I have pushed the current state of these patches to the
>> scsi-target-for-v4.11 branch of
>> https://git.kernel.org/cgit/linux/kernel/git/bvanassche/linux.git/
>
>
> Awesome,
>
> Robert, would it be possible to give the above tree:branch a try?
>
> I'll be surprised if this doesn't reproduce here, but at least try
> and get some valuable information.
