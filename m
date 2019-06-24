From: Ajay Kaher <akaher@vmware.com>
Subject: [PATCH v4 0/3] [v4.9.y] coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
Date: Tue, 25 Jun 2019 02:33:06 +0530
Message-ID: <1561410186-3919-4-git-send-email-akaher@vmware.com>
References: <1561410186-3919-1-git-send-email-akaher@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1561410186-3919-1-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
To: aarcange@redhat.com, jannh@google.com, oleg@redhat.com, peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com, mhocko@suse.com
Cc: jglisse@redhat.com, akpm@linux-foundation.org, mike.kravetz@oracle.com, viro@zeniv.linux.org.uk, riandrews@android.com, arve@android.com, yishaih@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, matanb@mellanox.com, leonro@mellanox.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, akaher@vmware.com, srivatsab@vmware.com, amakhalov@vmware.com
List-Id: linux-rdma@vger.kernel.org

coredump: fix race condition between mmget_not_zero()/get_task_mm()
and core dumping

[PATCH v4 1/3]:
Backporting of commit 04f5866e41fb70690e28397487d8bd8eea7d712a upstream.

[PATCH v4 2/3]:
Extension of commit 04f5866e41fb to fix the race condition between
get_task_mm() and core dumping for IB->mlx4 and IB->mlx5 drivers.

[PATCH v4 3/3]
Backporting of commit 59ea6d06cfa9247b586a695c21f94afa7183af74 upstream.

[diff from v3]:
- added [PATCH v4 3/3]
