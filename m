From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: OFED 1.5.4.1 on Ubuntu 10.04 with Mellanox cards?
Date: Fri, 22 Jun 2012 10:43:58 +0200
Message-ID: <4FE4304E.3090002@profitbricks.com>
References: <1565389.HptLAFPzES@twitter>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060007020706030201090401"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1565389.HptLAFPzES@twitter>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chet-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060007020706030201090401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Chet,

the trick is to check out the latest pkg-ofed source from debian SVN
(svn://svn.debian.org/svn/pkg-ofed/) and to update the upstream source
by merging the stuff by extracting the source RPMs or even better by
importing the source directly from the git repos of the OFED user space.
In the "debian" directory there are some patches e.g. which change some
stuff in shell scripts for the dash. These need to be adopted.

But you'll have to ensure that the kernel code matches the OFED user
space. The kernel stuff included in OFED doesn't support latest kernels
and is based on an older code base (e.g. OFED 1.5.4 kernel stuff is
based on 2.6.30). I hope that you don't need iSER. The open-iscsi kernel
stuff in there is also based on 2.6.30 which means that you would need
old open-iscsi user space.

This is why we've decided to follow what they call "upstream" in this
list. This means: Use the OFED kernel code from the matching vanilla
kernel from kernel.org.

Here a simple list of matching code:
OFED-1.5.4  ---> kernel 3.2.x
OFED-1.5.4.1 ---> kernel 3.3.x

I've attached the IB user space HOWTO from Or Gerlitz for the git repos.
Some of the git repos already have a debinan directory.

Do you know how to build Debian packages?

Cheers,
Sebastian


On 22/06/12 02:46, Chet Murthy wrote:
> 
> Hi,
> 
> A long while ago, I got OFED 1.5.2 working on Ubuntu 10.04 (Lucid) on
> Opterons with Mellanox DDR cards.  It was a little messy, getting the
> RPMs compiled, but it was pretty straightforward.  Basically, I (a)
> built a kernel with neither infiniband nor mellanox ethernet drivers,
> and (b) ran the OFED install.pl with some minor modifications to
> convert the RPMs into DEBs as they were built.  And everything worked,
> smooth as a whistle.
> 
> Today, I tried to do the same thing with OFED 1.5.4.1, and while the
> process of -building- was straightforward, once I get done, the card's
> state is all zeroes:
> 
> chet@memstore3:~$ sudo ibstatus
> Infiniband device 'mlx4_0' port 1 status:
>         default gid:     0000:0000:0000:0000:0000:0000:0000:0000
>         base lid:        0x0
>         sm lid:          0x0
>         state:           1: DOWN
>         phys state:      3: Disabled
>         rate:            2.5 Gb/sec (1X)
>         link_layer:      Ethernet
> 
> Infiniband device 'mlx4_0' port 2 status:
>         default gid:     0000:0000:0000:0000:0000:0000:0000:0000
>         base lid:        0x0
>         sm lid:          0x0
>         state:           1: DOWN
>         phys state:      3: Disabled
>         rate:            2.5 Gb/sec (1X)
>         link_layer:      Ethernet
> 
> The card's a modern ConnectX
> 
> 1f:00.0 Ethernet controller: Mellanox Technologies MT26448 [ConnectX EN 
> 10GigE, PCIe 2.0 5GT/s] (rev b0)
> 
> and on identical RedHat machines, the card's status is quite
> different:
> 
> 
> [root@memstore4 chet]# ibstatus
> Infiniband device 'mlx4_0' port 1 status:
>         default gid:     fe80:0000:0000:0000:0202:c9ff:fe4b:5890
>         base lid:        0x0
>         sm lid:          0x0
>         state:           1: DOWN
>         phys state:      3: Disabled
>         rate:            10 Gb/sec (1X QDR)
>         link_layer:      Ethernet
> 
> Infiniband device 'mlx4_0' port 2 status:
>         default gid:     fe80:0000:0000:0000:0202:c9ff:fe4b:5891
>         base lid:        0x0
>         sm lid:          0x0
>         state:           4: ACTIVE
>         phys state:      5: LinkUp
>         rate:            10 Gb/sec (1X QDR)
>         link_layer:      Ethernet
> 
> I'm not even sure how to go about debugging this.  Has anybody gotten
> OFED to work on Ubuntu with such modern cards?
> 
> Thanks,
> --chet--
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--------------060007020706030201090401
Content-Type: text/plain;
 name="IB-user-space-howto.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="IB-user-space-howto.txt"

	   IB user space HOWTO

		June 2012

	Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This little note attempts to get you through how to get the upstream 
user-space IB packages, specifically libibverbs/libmlx4/librdmacm and/or 
opensm and the IB diags.

Under Fedora / RHEL, installing the INBOX user-space IB/RDMA offering is easy as 

# yum groupinstall "Infiniband Support"

The IB service is called rdma (vs. openibd which used to be the name in older RHEL/Fedora
releases) and there is an rpm named "rdma" with various scripts. Note that this will 
not install opensm/diags (see below).

If you are seeking the latest RELEASE done by the maintainers, its also trivial, 
the releases are provided in the form of tar balls which you plug into 
"rpmbuild -ts" and you have fresh source RPM to build and later install.

Going more hackish, you would need to build the sources from the maintainers 
git, the git trees contain spec files, so the process would be to create 
the tarballs and then repeat the rpmbuild excercise.

See below links to where there are tarball releases and the git trees where 
here gitweb links are provided, they have the git pointer to clone from inside.

Here's the list of maintainers

Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>    for libibverbs/libmlx4
Sean Hefty    <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> for librdmacm
Alex Netes    <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>  for opensm and libibumad 
Ira Weiny     <weiny2-i2BcT+NCU+M@public.gmane.org>      for libibmad and the IB diags 
Ido Shamai    <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>    for perftest (ib_send_bw and friends)

Roland and Sean are also the maintainers of the IB kernel stack. 

The mailing list for reporting issues is <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 
there's no need for subscription, please make sure to CC the list when 
you send email to the maintainer.

Last but not least, make sure to enjoy your work, its really simple, 
and please do let me know if/what something is missing here.

tarballs based releases  

libibverbs	https://openfabrics.org/downloads/verbs 
libmlx4		https://openfabrics.org/downloads/mlx4 
librdmacm	https://openfabrics.org/downloads/rdmacm
perftest	https://openfabrics.org/downloads/perftest

opensm, libibumad, libibmad and infiniband-diags under
		https://openfabrics.org/downloads/management

GIT

libibverbs	http://git.kernel.org/?p=libs/infiniband/libibverbs.git;a=summary 
libmlx4		http://git.kernel.org/?p=libs/infiniband/libmlx4.git;a=summary 
librdmacm	http://git.openfabrics.org/git?p=~shefty/librdmacm.git;a=summary 
opensm		http://git.openfabrics.org/git?p=~alexnetes/opensm.git;a=summary
libibumad	http://git.openfabrics.org/git?p=~alexnetes/libibumad.git;a=shortlog	
ib-diags	http://git.openfabrics.org/git?p=~iraweiny/infiniband-diags.git;a=summary
libibmad	http://git.openfabrics.org/git?p=~iraweiny/libibmad.git;a=summary	
diags look for the git trees under which belong to Ira Weiny

# yum groupinfo "Infiniband Support"
Loaded plugins: product-id, security, subscription-manager
Updating certificate-based repositories.
Setting up Group Process

Group: Infiniband Support
Description: Software designed for supporting clustering and grid connectivity using RDMA-based InfiniBand and iWARP fabrics.
Mandatory Packages:
   libibcm
   libibverbs
   libibverbs-utils
   librdmacm
   librdmacm-utils
   rdma
Default Packages:
   dapl
   ibsim
   ibutils
   libcxgb3
   libibmad
   libibumad
   libipathverbs
   libmlx4
   libmthca
   libnes
   rds-tools
Optional Packages:
   compat-dapl
   infiniband-diags
   libibcommon
   mstflint
   opensm
   perftest
   qperf
   srptools


--------------060007020706030201090401--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
