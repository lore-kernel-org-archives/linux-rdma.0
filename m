From: Ajay Kaher <akaher@vmware.com>
Subject: [PATCH v5 0/3] [v4.9.y] coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
Date: Tue, 2 Jul 2019 00:02:08 +0530
Message-ID: <1562005928-1929-4-git-send-email-akaher@vmware.com>
References: <1562005928-1929-1-git-send-email-akaher@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1562005928-1929-1-git-send-email-akaher@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: aarcange@redhat.com, jannh@google.com, oleg@redhat.com, peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com, mhocko@suse.com
Cc: jglisse@redhat.com, akpm@linux-foundation.org, mike.kravetz@oracle.com, viro@zeniv.linux.org.uk, riandrews@android.com, arve@android.com, yishaih@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, matanb@mellanox.com, leonro@mellanox.com, gregkh@linuxfoundation.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, akaher@vmware.com, srivatsab@vmware.com, amakhalov@vmware.com
List-Id: linux-rdma@vger.kernel.org

coredump: fix race condition between mmget_not_zero()/get_task_mm()
and core dumping

[PATCH v5 1/3]:
Backporting of commit 04f5866e41fb70690e28397487d8bd8eea7d712a upstream.

[PATCH v5 2/3]:
Extension of commit 04f5866e41fb to fix the race condition between
get_task_mm() and core dumping for IB->mlx4 and IB->mlx5 drivers.

[PATCH v5 3/3]
Backporting of commit 59ea6d06cfa9247b586a695c21f94afa7183af74 upstream.

[diff from v4]:
- Corrected Subject line for [PATCH v5 2/3], [PATCH v5 3/3]
