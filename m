From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 11/12] uapi: export all arch specifics directories
Date: Mon, 15 May 2017 18:02:20 -0700
Message-ID: <CAA9_cmf1LXqYmOwad0sRjGyLRyhVOo8W-bcLkp-XFK9sQiFuhg@mail.gmail.com>
References: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com> <1490617217-30192-12-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1490617217-30192-12-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: yamada.masahiro@socionext.com, Arnd Bergmann <arnd@arndb.de>, mmarek@suse.com, linux-kbuild@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, airlied@linux.ie, David Miller <davem@davemloft.net>, linux@armlinux.org.uk, Borislav Petkov <bp@alien8.de>, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, Christoph Hellwig <hch@infradead.org>, tklauser@distanz.ch, Michael Ellerman <mpe@ellerman.id.au>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, ldv@altlinux.org, Herbert Xu <herbert@gondor.apana.org.au>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 27, 2017 at 5:20 AM, Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> This patch removes the need of subdir-y. Now all files/directories under
> arch/<arch>/include/uapi/ are exported.
>
> The only change for userland is the layout of the command 'make
> headers_install_all': directories asm-<arch> are replaced by arch-<arch>/.
> Those new directories contains all files/directories of the specified arch.
>
> Note that only cris and tile have more directories than only asm:
>  - arch-v[10|32] for cris;
>  - arch for tile.
>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Starting with commit 61562f981e92 "uapi: export all arch specifics
directories", a "make INSTALL_HDR_PATH=$root/usr headers_install"
operation will delete standard glibc headers and others in
$root/usr/include.

Here's the snippet from the build process where it deletes system
headers with this commit:

  CHK     include/generated/uapi/linux/version.h
  INSTALL include/linux/nfsd (5 files)
  INSTALL include/linux (482 files)
  REMOVE  libgen.h resolv.h paths.h syscall.h spawn.h unistd.h ar.h
setjmp.h termio.h wchar.h semaphore.h fcntl.h fpu_control.h glob.h
termios.h nss.h fmtmsg.h shadow.h crypt.h aio.h grp.h uchar.h
libudev.h argz.h utime.h complex.h obstack.h argp.h math.h sched.h
xlocale.h netdb.h link.h mqueue.h ulimit.h regex.h fstab.h sgtty.h
iconv.h dirent.h inttypes.h pty.h locale.h utmp.h pthread.h gconv.h
lastlog.h assert.h endian.h stdio_ext.h signal.h search.h ctype.h
execinfo.h values.h re_comp.h libio.h ustat.h printf.h getopt.h time.h
stab.h stdlib.h gshadow.h mntent.h stdc-predef.h libkmod.h memory.h
nl_types.h mcheck.h errno.h poll.h fnmatch.h limits.h ucontext.h
libintl.h envz.h stdio.h wait.h monetary.h _G_config.h dlfcn.h
wordexp.h string.h pwd.h tar.h proc_service.h tgmath.h byteswap.h
elf.h cpio.h aliases.h wctype.h ftw.h ieee754.h err.h langinfo.h fts.h
features.h gnu-versions.h malloc.h regexp.h stdint.h ifaddrs.h
syslog.h error.h a.out.h utmpx.h sysexits.h fenv.h ttyent.h alloca.h
thread_db.h strings.h
