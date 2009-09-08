From: Jeff Squyres <jsquyres@cisco.com>
Subject: [ofa-general] Re: [PLEASE READ] Transition from
	general@lists.openfabrics.org to linux-rdma@vger.kernel.org
Date: Tue, 8 Sep 2009 08:20:35 -0400
Message-ID: <D0F1F48E-388B-4E39-A093-F1FC389CBBAB@cisco.com>
References: <adaocpmm3ue.fsf@cisco.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <adaocpmm3ue.fsf@cisco.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: linux-rdma@vger.kernel.org, OpenFabrics General <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

+1 to everything Roland said (I'm deleting  
general@lists.openfabrics.org from my addressbook after sending this).

I'd suggest making a clean break -- on 1 Oct, make "general@lists.openfabrics.org 
" autoreply with something like "This list has moved; please re-send  
your message to linux-rdma@vger.kernel.org" or somesuch.



On Sep 8, 2009, at 12:56 AM, Roland Dreier (rdreier) wrote:

> Hi everyone,
>
> As you may have noticed, the linux-rdma@vger.kernel.org list is up and
> running.  A number of sites have started archiving it -- in no
> particular order, the sites I know of are:
>
>     http://www.spinics.net/lists/linux-rdma/
>     http://marc.info/?l=linux-rdma
>     http://www.mail-archive.com/linux-rdma@vger.kernel.org/
>     http://dir.gmane.org/gmane.linux.drivers.rdma
>
> If you know of any archives I've missed, please let me know.
>
> Another nice tool we have with the new list is
>
>     http://patchwork.kernel.org/project/linux-rdma/list/
>
> which will make me have to work a little harder to lose patches.   
> Also,
> if you are someone who handles a driver or some other part of the  
> tree,
> you can register and I will be able to delegate patches to you.
>
> I would suggest that everyone who is currently following
> general@lists.openfabrics.org to subscribe to the new list (send the
> line "subscribe linux-rdma" in the body of a message to
> majordomo@vger.kernel.org).  Also, everyone sending email to the old
> list to also please start to copy the new vger list as well  
> (especially
> for patches, so that the patchwork tool catches them).
>
> As a date to finalize the transition, I propose the end of the month  
> --
> that is, on October 1 we shut down the old general@ list and expect
> everything to be cut over by then.  I'll send a number of reminders
> before then, but please do speak up if this schedule is too tight -- I
> don't think keeping the old list running for longer is a big hardship
> for anyone.
>
> Finally, I'll plan to merge the following for 2.6.32:
>
>
> MAINTAINERS: InfiniBand/RDMA mailing list transition to vger
>
> InfiniBand/RDMA development discussion is moving from
> general@lists.openfabrics.org to linux-rdma@vger.kernel.org.
>
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
>  MAINTAINERS |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8dca9d8..989ff11 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -439,7 +439,7 @@ F:  drivers/hwmon/ams/
>  AMSO1100 RNIC DRIVER
>  M:     Tom Tucker <tom@opengridcomputing.com>
>  M:     Steve Wise <swise@opengridcomputing.com>
> -L:     general@lists.openfabrics.org
> +L:     linux-rdma@vger.kernel.org
>  S:     Maintained
>  F:     drivers/infiniband/hw/amso1100/
>
> @@ -1494,7 +1494,7 @@ F:        drivers/net/cxgb3/
>
>  CXGB3 IWARP RNIC DRIVER (IW_CXGB3)
>  M:     Steve Wise <swise@chelsio.com>
> -L:     general@lists.openfabrics.org
> +L:     linux-rdma@vger.kernel.org
>  W:     http://www.openfabrics.org
>  S:     Supported
>  F:     drivers/infiniband/hw/cxgb3/
> @@ -1868,7 +1868,7 @@ F:        fs/efs/
>  EHCA (IBM GX bus InfiniBand adapter) DRIVER
>  M:     Hoang-Nam Nguyen <hnguyen@de.ibm.com>
>  M:     Christoph Raisch <raisch@de.ibm.com>
> -L:     general@lists.openfabrics.org
> +L:     linux-rdma@vger.kernel.org
>  S:     Supported
>  F:     drivers/infiniband/hw/ehca/
>
> @@ -2552,7 +2552,7 @@ INFINIBAND SUBSYSTEM
>  M:     Roland Dreier <rolandd@cisco.com>
>  M:     Sean Hefty <sean.hefty@intel.com>
>  M:     Hal Rosenstock <hal.rosenstock@gmail.com>
> -L:     general@lists.openfabrics.org (moderated for non-subscribers)
> +L:     linux-rdma@vger.kernel.org
>  W:     http://www.openib.org/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/roland/ 
> infiniband.git
>  S:     Supported
> @@ -2729,7 +2729,7 @@ F:        drivers/net/ipg.c
>
>  IPATH DRIVER
>  M:     Ralph Campbell <infinipath@qlogic.com>
> -L:     general@lists.openfabrics.org
> +L:     linux-rdma@vger.kernel.org
>  T:     git git://git.qlogic.com/ipath-linux-2.6
>  S:     Supported
>  F:     drivers/infiniband/hw/ipath/
> @@ -3485,7 +3485,7 @@ F:        drivers/scsi/NCR_D700.*
>  NETEFFECT IWARP RNIC DRIVER (IW_NES)
>  M:     Faisal Latif <faisal.latif@intel.com>
>  M:     Chien Tung <chien.tin.tung@intel.com>
> -L:     general@lists.openfabrics.org
> +L:     linux-rdma@vger.kernel.org
>  W:     http://www.neteffect.com
>  S:     Supported
>  F:     drivers/infiniband/hw/nes/
> --
> 1.6.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Jeff Squyres
jsquyres@cisco.com
