From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: srp-ha backport
Date: Sat, 15 Sep 2012 11:23:58 +0200
Message-ID: <5054492E.1090403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

In case anyone would like to start using the srp-ha patch series before
it gets upstream, a backported version of that patch series is available
here: http://github.com/bvanassche/ib_srp-backport. The advantages of
that version of ib_srp over what's upstream are:
- Better robustness against cable plugging.
- Allows closing an SRP connection from the initiator side (via the
  new "delete" attribute in sysfs).
- Configurable dev_loss_tmo and fast_io_fail_tmo parameters.
- Builds against any kernel in the range 2.6.32..3.6.
- Can be used on RHEL 6.x systems.

In combination with srp_daemon and multipath-tools this should allow to
build a reliable H.A. SRP solution.

Note: I haven't been able to test that code against every existing
mainstream or distro kernel. Feedback is welcome though.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
