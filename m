From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [ofa-general] Re: Merge process for OFED patches
Date: Wed, 16 Sep 2009 15:08:01 +0200
Message-ID: <e2e108260909160608r174fd10bu4a5fd9e34d100783@mail.gmail.com>
References: <e2e108260909160544r6a1099afvadd3e9b80a84a748@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <e2e108260909160544r6a1099afvadd3e9b80a84a748@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, OpenIB <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 16, 2009 at 2:44 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> I noticed that there are six SRP patches (bug fixes) present in OFED
> 1.4.1 that are not present in mainstream Linux kernels up to and
> including version 2.6.30. Do you know whether it is documented
> anywhere which process is followed for merging such patches in the
> mainstream Linux kernel ?

By the way, these are the SRP patches included in OFED 1.4.1:
* ofa_kernel-1.4.1/kernel_patches/fixes/srp_1_recreate_at_reconnect.patch
* ofa_kernel-1.4.1/kernel_patches/fixes/srp_2_disconnect_without_wait.patch
* ofa_kernel-1.4.1/kernel_patches/fixes/srp_3_reset_req_with_status.patch
* ofa_kernel-1.4.1/kernel_patches/fixes/srp_4_dev_loss_tmo.patch
* ofa_kernel-1.4.1/kernel_patches/fixes/srp_5_async_event_handler.patch
* ofa_kernel-1.4.1/kernel_patches/fixes/srp_6_target_in_out_of_fabric.patch

Bart.
