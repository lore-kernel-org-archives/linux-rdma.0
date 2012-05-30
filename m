From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH v3 0/8] Mkey support in infiniband-diags
Date: Wed, 30 May 2012 10:20:14 -0700
Message-ID: <1338398414.11948.29.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

     I am about to send V3 of the patch set.  Changes include:

. There is now a common "-K" option which must be passed in order to
view "sensitive" credentials.  Data is shown as "<not displayed>" rather
than as invalid/all zeros, as an indication to the user that they should
pass -K in order to see it.

. Documentation is migrated to restructured text and cleaned up
significantly.

. The config file now accepts a "sa_smkey" parameter, which sets the
smkey used in SA requests.  The default config file continues to set
this to 0 to discourage bad security practice, but the user can now
configure their own default as they wish.

. The changes to ibportstate to display and modify mkey-related
parameters have been broken out into two separate patches, and the patch
series reordered into a more logical progression.

     Jim

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
