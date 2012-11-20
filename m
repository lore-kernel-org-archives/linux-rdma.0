From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: srp-ha backport
Date: Tue, 20 Nov 2012 04:04:14 +0000 (UTC)
Message-ID: <loom.20121120T050107-224@post.gmane.org>
References: <5054492E.1090403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche <bvanassche@...> writes:

> 
> Hello,
> 
> In case anyone would like to start using the srp-ha patch series before
> it gets upstream, a backported version of that patch series is available
> here: http://github.com/bvanassche/ib_srp-backport. The advantages of
> that version of ib_srp over what's upstream are:
> - Better robustness against cable plugging.
> - Allows closing an SRP connection from the initiator side (via the
>   new "delete" attribute in sysfs).
> - Configurable dev_loss_tmo and fast_io_fail_tmo parameters.
> - Builds against any kernel in the range 2.6.32..3.6.
> - Can be used on RHEL 6.x systems.
> 
> In combination with srp_daemon and multipath-tools this should allow to
> build a reliable H.A. SRP solution.
> 
> Note: I haven't been able to test that code against every existing
> mainstream or distro kernel. Feedback is welcome though.

Thanks for this backport! I have some problem under sles 11 sp2 (kernel 3.0.42-
0.7-xen) then i shutdown srp target (reboot one sas server) multipath -ll does 
not respond. If i provide in multipath and srp identical dev_loss_tmo and 
fast_io_fail_tmo nothing changed. multipath -ll unblocks only then the server 
goes up.

dev_loss_tmo = 15
fast_io_fail_tmo = 10

multipath.conf
defaults {
        getuid_callout       "/bin/cat /sys/block/%n/device/model" 
        path_grouping_policy failover
        failback 	     immediate
        no_path_retry        fail
        path_checker         tur
        rr_weight	     uniform
        rr_min_io            100
        polling_interval     10
        checker_timeout      10
	fast_io_fail_tmo     60
	dev_loss_tmo         120
}
blacklist {
        devnode cciss
        devnode fd
        devnode hd
        devnode md
        devnode sr
        devnode scd
        devnode st
        devnode ram
        devnode raw
        devnode loop
}




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
