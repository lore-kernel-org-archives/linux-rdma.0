From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: 2nd RDMA Miniconference Summary
Date: Sun, 17 Sep 2017 15:56:03 +0300
Message-ID: <20170917125603.GA5788@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

We would like to thank you for all presenters and attendees of
the 2nd RDMA miniconference at the LPC 2017.

Special thanks goes to Ram Amrani who did an excellent job to summarize
the discussions and to Jason Gunthrope together with Christoph Lameter who
helped me to organize and run this conference.

The original etherpad is located at https://etherpad.openstack.org/p/LPC2017_RDMA
and below you will find the copy of those notes:

* Main Track
----------------------------------------------------------------------------------------------------------------------------
*  Backporting issues with multi-subsystem device (RDMA + netdev + more) - Don Dutile
http://linux-rdma.org/docs/lpc-2017-rdma-backport-don-dutile.pdf
	* RDMA customers want the latest, closest to upstream
	* no kabi, no OOB drivers supported
	* RDMA includes: drivers/infiniband/... core, ulp (iSER,, IPoIB, ...), sw (soft RoCE, ...), hw (vendors)
		* Entangled with net/ethernet/... makes life harder
		* user-space packages (rdma-core)
		* and newer: NFSoRDMA, cgroups, SELinux
	* Process:
		* generate commit list from git - easy
		* split work between Don and partners
		* Work with quilt - its faster than git rebase when working with many patches (yay)
		* Take 1,2,3, ..more weeks (yikes)
	* Subsystem dependencies
		* net, NFS, iSCSI, target, block(?)
	* Problems encountered
		* inline functions caused issue creating more kABIs (?)
		* at times will require to backport many other patches to support
	* Testing - partners test; regression (used by devel, QE and Doug as well)
	* Help Don/backporting
		* conditionally configure new features
		* refactor once to minimize the number of patches
		* keep older drivers maintained
		* Don't submit patches with build warnings


*  uABI Update - Matan Barak
	* main purpose: enable it by default
	* goals of uABI
		* resolve write() security issue
		* an extensible approach
			* #1 - extensible verbs
			* #2 - vendor specific - objects, methods and attributes
		* and more: automatic syntatic check, backward compatability, efficiency
	* The approach is similar to object oriented programming
		* Objects - cq, qp, ...
		* Methods- create qp, modify qp, create cq, ...
		* Attributes - qp handle, qp type, ...
	* Parsing trees types
		* Common feature-set - QP, CQ, MW, MR, PD
		* specific feature - device, CQ
		* driver-specific feature - e.g., MLX object, CQ, QP
	* The consolidated driver specific parsing tree will be created from the *supported* common/specific/driver-specific features listed above
	* user-space passes an ID that is a 16bit unique number to identify the operation
	* Method = name + ID + handler + attributes
	* Next
		* try the accepted patches yourself. already two verbs are implemented (cq create/destroy)
		* transition -
			* will need to move *all* verbs to resolve the security issue; will need to recode RDMA CM,...
			* But can start transition now to enjoy the extensibility and vendor specific perk
			* hopefully we could remove the "experimental" before we transition everything (will take time to convert all..., more than 2 years)
			* Red Hat won't take anything in experimental...
			* force new features to use the new API?
			* choose minimal verb list before removing the 'experimental'?
			* compat suggestion: have the old API actually use the new API under the hood


*  System Boot and RDMA - Jason Gunthorpe
http://linux-rdma.org/docs/lpc-2017-boot-jason-gunthrope.pdf
	* To do
		* hot plug ordering requires binding to RDMA device name
		* allow requires/bindsto port GUID
		* kernel autoload modues
		* report RDMA driver from kernel; have ther kernel tell user space the RDMA technology
	* Next steps
		* create a udev helper
	* Problems
		* RDMA lacks autoloading
		* RDMA device load latency issue
		* use rdma-netlink to autoload uAPI modules?
		* autoload iSER target, SRP target, ... how? NFS?
		* predictable or persistent device names?
			* need to be able to rename a device
			* have udev to invoke the renaming
		* what names to use?
			* can we have the 'name' relate to the physical port?
			* for RoCE and iWARP, single port, we can simply rely on the Ethernet device names. So it is more relevant to IB
			* perhaps netdev_n for multi-port of Ethernet based
		* the sysadmin will be able to disable this for "backward support"
		* link-down on bootup?
			* IB, OPA start with link up but RoCE and iWARP with link down
			* Liran: this will be a problem for IB as it uses inband for managment. Even more problematic in large clusters
			* Liran: link down due to boot can cause issues with switches


*  Paravirtual RDMA device - Marcel Apfelbaum, Yuval Shaia
http://linux-rdma.org/docs/lpc-2017-pvrdma-marcel-apfelbaum-yuval-shaia.odp
	* Why?
		* migration
		* overcommit
		* guests will be device agnostic
		* not dependent on SRIOV
	* Check small/large packer performance against
		* Ethernet virtio NIC
		* PVRDMA RoCE over soft RoCE
		* PVRDMA RoCE with phys RDMA VF
	* How this works
		* virtualize all resources with a 1-1 mapping: PDs, CQs, QPs, ..
		* create minimum meta-data that is passed.
	* Open issues
		* RDMA CM support - post virtual RDMA CM messages as umad
		* need user-space contiguous physical memory (API uses single key currently)
		* guest is not trusted, and without pinning this can cause issues (ODP is a possibility, not available in all devices)
		* migration
			* keep QP numbers over migration?! and what about QP states?!
				* can we mark a QP as "busy, try again later"? Liran: can be implemented as extended verb
			* can suffer packet loss? Liran: play with timeout configurations (during run-time?!)
	* Future
		* Submit VMware's PVRDMA device implementaion to QEMU. Submit RoCE v2 support
		* Better performance
		* move to a virtio based RDMA device
			* queue for the command channel; queue per SQ,RQ,CQ


*  OpenFabrics Alliance - Status and New Directions - Jason Gunthorpe
http://linux-rdma.org/docs/lpc-2017-ofa-jason-gunthrope.pdf
	* Jason was elected to represent the community at OFA, along with Bob
	* Jason encourages all developers to review presentation and communicate with their company's OFA representative
	* Today OFA - holds an yearly conference,  marketing, hosting some, ...
		* With help of others - OFED, ...
	* It doesn't -
	* changes?
		* open source licensing type
		* transition to open source non-profit
		* and perhaps: directly fund development and/or shared cloud resources; only manage yearly workshop; revising logo events at UNH-IOL
	* possible
		* host github and other platforms
		* organize meetings with neutral atmosphere
		* represent against the linux foundation
		* backport OFED (?)
		* establish a technical board
	* Leon is against any OFA involvement in upstream projects.

*  BOF - Open Discussion
	* Skipped due to lack of the time


* Round Table Track (Platinum J)
Attendees: Jason G, Leon R., Liran L. Yuval S., Marcel A., Knut, Joantahn T., Don D.,Jeff B., Bart V.A., Christoph L., Yaron, Ram A,Niranjana, Chaitanya Kulkami
------------------------------------------------------------------------------------------------------------------------------------------------------------------
* linux-rdma
	* Doug is doing a good job passing patches to Linux.
	  Would appreciate better communication. faster and more continuous i.e. less bursty.
	* general consensus that patches should be processed continuously.
	  Poll shows significant and broad discontent from missing 4.13.
	* Uncertainty about the steps that are performed by the maintainer prior to upstreaming.
	* Suggested solution: co-maintainership. Requires team to work together to form pull request to Linus
		* Marcel says qemu works with sub maintainers, but areas are more isolated
		* Christoph says slab subsystem has been working with co-maintainers for years
		* Leon: Team has already been working like this for rdma-core since its start.
	* Jason: Doug/RH is the only one (in the world)! that can comprehensively check RDMA widely,
	  his test lab has all hardware
		* How come 4.1x was broken for so long? Don: regressions was down for a while
		  Leon: Takes responsibility for bad patch, approved of fix
		* It is a scalability problem expecting Doug to be in charge of testing everything -
		  Jason: Can't scale if only Doug can test -> must separate test from patch flow
		* expectation that each vendor's QA will be proactive and test before submitting
		* Jason: Linus has said perfect is not the goal, but being fast to correct mistakes is crucial
	* Bart, Liran: split the responsibilities of reviewing and testing (Bart likens things to SCSI)
	* Christoph, Leon, Jason: focus on source code integration before merge period not on functionality
	  verification (can still be done using linux-next if wanted).
		* Eg get clean pull request into Linus's tree for early merge window,
		  then switch to testing during RC period (rc is the proper period to do
		  full functionality testing and there are up to 10 weeks or so
		  reserved for that purpose). This tests entire release including other
		  subsystems to find global integration problems.
		* QA MUST test RC releases, far more important than testing pull request.
	* Vendor QA needs a solid rapidly moving tree to QA against, otherwise QA waits for merge window - lost early QA opportunities.
	* Question: Why is Doug using RH regression to begin with? According to Christoph it isn't expected
	  from a maintainer to do large scale integration testing to prepare full request)
	* Group appreciates all testing being done by all parties
	* Clear expectation from the group: focus on clean merge with Linus;
	  Not expected: full comprehensive integration testing (to prepare pull request)
	* Jonathan: Dave Miller's approach to bad patches is "you have X days to fix it before I pull out your patch series".
	  Patches can be pulled in rc period.
	* Marcel: our expectation in qemu is up to 2 weeks to get a patch to the tree of maintainer, but this is a fairly reliable cadence
	* Request: clear equivalent to net and to net-next (aren't the branches "for rc-4.1x" and for rc-4.1x+1"?)
		* maybe just make things less bursty, more clear?
	* Question: Is anyone using Doug's github? Do we need this rebasable tree? Consensus is no to both
		* Linus is generally against rebasing
		* reduces maintainer's responsibility and work?
	* Mellanox folks: not sure what to test against; wasting resources to ensure they got coverage, by testing combinations
	* Knut: Wish (at least) for a 'readme' per branch describing what is in it
	* Yaron: the way rdma-core is maintained is extremely well (general agreement in room)
	  (n.b. Jason: All vendors have privately complemented rdma-core)
	* Jason: co-maintainer goal is to ensure patches reach Linus in case one maintainer
	  is unavailable, provide a succession path, grow skill in the community and spread
	  the work load of merging and reviewing patches.
	* Christoph: Co-maintainers are good to improve communications and provide early feedback.
	  Enhances the quality of maintainership.
	* General agreement: it is not feasible and/or possible to push net+rdma entagled patches
	  with a delay of one kernel release as Doug proposes
	* Resolution: schedule a conference call Doug+Jason+Leon


* PVRDMA
	* Soft RoCE should support communication on the same machine between
	  different rxe devices. If this doesn't work then it is a bug
	* Supporting multiple QP numbers should be done with additional device structures
	* sg based userspace MR creation should be a straightforward implementation with a new verb,
	  suggest building the new uABI verbs to accept an array from the start.


* QP information through RDMAtool
	* user will use a QPN (for example), but kernel uses pointer. need to see how to translate QPN --> pointer
		* we want to limit the size of the lookup. Currently we are less interested by speed
		  (although there are customers with thousands of nodes that are interested with this...)
		* suggestion: just do linear search. this will be slow but will be a good place to start with...
		* Suggestion: work in a PD scope to limit the lookup
	* already operational :-)

* Integration gaps for rdma-core
	* Need to explore other platforms to run CI in containerized mode, the candidates are GCE, CircleCI, e.t.c.
	* That platform should allow conversion from man pages to documentation, website update and distro packages builds

* Existing RDMA CM statistics through netlink
	* No one really knows what is it and it looks like good candidate to be deprecated before anyone starts to use it.
	* It is implemented in non-netlink way and have very high chances to be broken.

* RDMA netlink and RDMAtool future plans
	* QP information
	* Device statistics
	* Provider specific configurations

Thanks

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm+cOMACgkQ5GN7iDZy
WKcGmg//XvdIYtMaVA3oOhXS08m2+7Ko0h4ap0VXq1D0QClwMpday802HXDkv0TE
DWQLYkQJ/tjv62JU+1KkPuVn2YuruD8HDze+GOKE30ilLzSnm4CiwbKCpwpVXA8G
cL4N6AXVv3HwjibCSWCM945pEl3XlqMoKOQL4yEIUlG8rs0lgOaQTWfOe704GPjf
qJd9tGghVMJUDkWzdYPdbs5kvy1KjkLpo+eHxxFtwzQdvQ0vULa+kAyEPOggKbWd
el3HvPE6qqcYtqaDUy/RzVPhHfqV/Voh/EnL6lkhDgSN1VWpSUXuS5uWx4ldckHu
zqmew4xut26LQXIMBbD13ZWAYH6NdKjAhAIB38u8ZUiCGQ9hfB7vbIA2nJmFh2a/
gW0FyqYSppGwpQXNsB5rbZzR5zS5RXFimiZI+J6xM4iXyuOD8S8LugQjHC8ZoS8X
u+UckmtIFw2JgiBMgHvixe3TXtlsB2zNK1Xa3q1LlLBfIG5akw4pCPvxVdxDgR7P
JaVk0VRba79ieejyMKOPs3CiGS2s9ZVUQfiI72IjAtJ9aPftSn7pT7nN8xdrlW4y
7YpIB/MTtkOI88CdBTgkYzsOMJNyiYNf+/8+U4lsDiwwNbg/ZYfvHPi+BhKWxeyL
jdRIZVsn1WR6t5aAhJ50+ljXDLUPHyS0r54bWK+ifKZsosrFarw=
=HVYR
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
