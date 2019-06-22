From: Ajay Kaher <akaher@vmware.com>
Subject: [PATCH v3 0/2] [v4.9.y] coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
Date: Sat, 22 Jun 2019 18:32:19 +0530
Message-ID: <1561208539-29682-3-git-send-email-akaher@vmware.com>
References: <1561208539-29682-1-git-send-email-akaher@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1561208539-29682-1-git-send-email-akaher@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: aarcange@redhat.com, jannh@google.com, oleg@redhat.com, peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com, mhocko@suse.com
Cc: jglisse@redhat.com, akpm@linux-foundation.org, mike.kravetz@oracle.com, viro@zeniv.linux.org.uk, riandrews@android.com, arve@android.com, yishaih@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, matanb@mellanox.com, leonro@mellanox.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, akaher@vmware.com, srivatsab@vmware.com, amakhalov@vmware.com
List-Id: linux-rdma@vger.kernel.org

coredump: fix race condition between mmget_not_zero()/get_task_mm()
and core dumping

[PATCH v3 1/2]:
Backporting of commit 04f5866e41fb70690e28397487d8bd8eea7d712a upstream.

[PATCH v3 2/2]:
Extension of commit 04f5866e41fb to fix the race condition between
get_task_mm() and core dumping for IB->mlx4 and IB->mlx5 drivers.

[diff from v2]:
- moved mmget_still_valid to mm.h in [PATCH v3 1/2]
- added binder.c changes in [PATCH v3 1/2]
- added [PATCH v3 2/2]
