From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 12:01:43 -0500
Message-ID: <00f601d30567$b1300140$139003c0$@opengridcomputing.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com> <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com> <20170725164004.GA20959@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> 
> > >
> > > Hey Jason,
> > >
> > > Thanks for doing all this!  I'm testing with cxgb4 today.
> > >
> > > I get these errors building the rpms using the spec file in your tree:
> >
> > I think you are using ./rdma-core.spec? I forgot about that one and
> > didn't make it work, I will fix it.
> >
> > You probably want to use redhat/rdma-core.spec anyhow?
> >
> 
> Ok.  I haven't been paying attention to the distro-specific stuff. I had a
process I
> have been following to build an rpm from ./rdma-core.spec.  I'll try the
redhat spec
> file since I'm installing on a RHEL7.2 system.

Hmm, the rdma-core rpm built ok, but there are no libs or commands in it. ?  I
think I'm in the weeds. here :)  

What I did was:

[root@stevo3 rdma-core-15]# git clone
https://github.com/jgunthorpe/rdma-plumbing rdma-core-15
[root@stevo3 rdma-core-15]# tar czf ~/rpmbuild/SOURCES/rdma-core-15.tgz
rdma-core-15
[root@stevo3 rdma-core-15]# rpmbuild -bb rdma-core-15/redhat/rdma-core.spec
[root@stevo3 rdma-core-15]# rpm --install
~/rpmbuild/RPMS/x86_64/rdma-core-devel-15-1.el7.x86_64.rpm
[root@stevo3 rdma-core-15]# rpm -ql rdma-core
/etc/modprobe.d/mlx4.conf
/etc/modprobe.d/truescale.conf
/etc/rdma
/etc/rdma/mlx4.conf
/etc/rdma/modules/infiniband.conf
/etc/rdma/modules/iwarp.conf
/etc/rdma/modules/opa.conf
/etc/rdma/modules/rdma.conf
/etc/rdma/modules/roce.conf
/etc/rdma/rdma.conf
/etc/rdma/sriov-vfs
/etc/sysconfig/network-scripts/ifdown-ib
/etc/sysconfig/network-scripts/ifup-ib
/etc/udev/rules.d/70-persistent-ipoib.rules
/usr/bin/rxe_cfg
/usr/lib/dracut/modules.d/05rdma
/usr/lib/dracut/modules.d/05rdma/module-setup.sh
/usr/lib/modprobe.d/libmlx4.conf
/usr/lib/systemd/system/rdma-load-modules@.service
/usr/lib/systemd/system/rdma-ndd.service
/usr/lib/systemd/system/rdma.service
/usr/lib/udev/rules.d/60-rdma-ndd.rules
/usr/lib/udev/rules.d/75-rdma-description.rules
/usr/lib/udev/rules.d/90-rdma-hw-modules.rules
/usr/lib/udev/rules.d/90-rdma-ulp-modules.rules
/usr/lib/udev/rules.d/90-rdma-umad.rules
/usr/lib/udev/rules.d/98-rdma.rules
/usr/libexec/mlx4-setup.sh
/usr/libexec/rdma-fixup-mtrr.awk
/usr/libexec/rdma-init-kernel
/usr/libexec/rdma-set-sriov-vf
/usr/libexec/truescale-serdes.cmds
/usr/sbin/rdma-ndd
/usr/share/doc/rdma-core-15
/usr/share/doc/rdma-core-15/README.md
/usr/share/doc/rdma-core-15/rxe.md
/usr/share/licenses/rdma-core-15
/usr/share/licenses/rdma-core-15/COPYING.BSD_FB
/usr/share/licenses/rdma-core-15/COPYING.BSD_MIT
/usr/share/licenses/rdma-core-15/COPYING.GPL2
/usr/share/licenses/rdma-core-15/COPYING.md
/usr/share/man/man7/rxe.7.gz
/usr/share/man/man8/rdma-ndd.8.gz
/usr/share/man/man8/rxe_cfg.8.gz

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
