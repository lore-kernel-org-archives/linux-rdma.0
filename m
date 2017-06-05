From: Moni Shoua <monis@mellanox.com>
Subject: Re: [PATCH V3] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Mon, 5 Jun 2017 12:21:15 +0300
Message-ID: <CAG9sBKNFUizb3EGHXC8ac_wrPEnDZ=yOoj0x0h-nL5GY=3TK0Q@mail.gmail.com>
References: <1496648342-906-1-git-send-email-baijiaju1990@163.com>
 <CAG9sBKNKTT8ceHrXRhLRns53ejH0kwaLMy-qAzdmo=Hy5h02Yw@mail.gmail.com> <5935190F.7090708@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5935190F.7090708@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: yuval.shaia@oracle.com, Sean Hefty <sean.hefty@intel.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> I agree.
> So, it is fine to me to remove this line, as you said in the former email:
>
Thanks.
Can you please send a patch like that?
