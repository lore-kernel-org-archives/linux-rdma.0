From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v4 0/3] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Date: Mon, 24 Jun 2019 16:21:50 -0400
Message-ID: <20190624202150.GC3881@sasha-vm>
References: <1561410186-3919-1-git-send-email-akaher@vmware.com>
 <1561410186-3919-4-git-send-email-akaher@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1561410186-3919-4-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
To: Ajay Kaher <akaher@vmware.com>
Cc: aarcange@redhat.com, jannh@google.com, oleg@redhat.com, peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com, mhocko@suse.com, jglisse@redhat.com, akpm@linux-foundation.org, mike.kravetz@oracle.com, viro@zeniv.linux.org.uk, riandrews@android.com, arve@android.com, yishaih@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, matanb@mellanox.com, leonro@mellanox.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, srivatsab@vmware.com, amakhalov@vmware.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 25, 2019 at 02:33:06AM +0530, Ajay Kaher wrote:
>coredump: fix race condition between mmget_not_zero()/get_task_mm()
>and core dumping
>
>[PATCH v4 1/3]:
>Backporting of commit 04f5866e41fb70690e28397487d8bd8eea7d712a upstream.
>
>[PATCH v4 2/3]:
>Extension of commit 04f5866e41fb to fix the race condition between
>get_task_mm() and core dumping for IB->mlx4 and IB->mlx5 drivers.
>
>[PATCH v4 3/3]
>Backporting of commit 59ea6d06cfa9247b586a695c21f94afa7183af74 upstream.
>
>[diff from v3]:
>- added [PATCH v4 3/3]

Why do all the patches have the same subject line?

I guess it's correct for the first one, but can you explain what's up
with #2 and #3?

If the second one isn't upstream, please explain in detail why not and
how 4.9 differs from upstream so that it requires a custom backport.

The third one just looks like a different patch altogether with a wrong
subject line?
