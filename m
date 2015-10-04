From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH] staging: rdma: Fix braces around if/else
Date: Sun, 4 Oct 2015 09:47:52 +0300
Message-ID: <5610CB98.1090907@mellanox.com>
References: <1b3a2e933e163bf11a2163c76bedd074551c1b9a.1443901389.git.mkletzan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1b3a2e933e163bf11a2163c76bedd074551c1b9a.1443901389.git.mkletzan@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Martin Kletzander <mkletzan@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On 10/3/2015 11:55 PM, Martin Kletzander wrote:
> Get rid of all ELSE_AFTER_BRACE type errors reported by checkpatch.pl.

Hi Greg,

Is there a way to signal people/tools that a certain driver parks in 
staging on their way **out** of the kernel
and not the other way around? I guess you (nor Doug) don't want to spend 
time on fixing such drivers, right?

Or.

>
> Signed-off-by: Martin Kletzander <mkletzan@redhat.com>
> ---
> There is one warning reported in this patch though.  That's because of
> the multiline string and it's pre-existing.  Feel free to let me know
> if that should be fixed too, I'd also remove the pointless '#' then.
> On the other hand, it'll create more-than-80-columns long line.
>
>   drivers/staging/rdma/ipath/ipath_driver.c    | 19 ++++++++-----------
>   drivers/staging/rdma/ipath/ipath_file_ops.c  | 12 ++++++------
>   drivers/staging/rdma/ipath/ipath_iba6110.c   |  7 +++----
>   drivers/staging/rdma/ipath/ipath_init_chip.c | 10 +++++-----
>   drivers/staging/rdma/ipath/ipath_intr.c      |  7 +++----
>   drivers/staging/rdma/ipath/ipath_sysfs.c     |  7 +++----
>   drivers/staging/rdma/ipath/ipath_verbs.c     |  4 ++--
>   7 files changed, 30 insertions(+), 36 deletions(-)
