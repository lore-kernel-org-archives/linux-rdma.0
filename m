From: Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Adding support for Debian packaging
Date: Thu, 21 Feb 2013 14:53:23 -0600
Message-ID: <CABweQmK6zBZSeeLShS8MpcFu6oHVvNw6CF_3sWbqe1dGM-BeUg@mail.gmail.com>
References: <1361441897-19486-1-git-send-email-ilyan@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361441897-19486-1-git-send-email-ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Ilya. I'm really glad to see Mellanox taking interest in the debian
family of distros.

A few quick comments about your patches. these don't quite follow the
typical approach of debian packaging in a few ways:
 - the maintainer field usually refers to the person that maintains
the packages, not necessarily the upstream package
 - generally the package changelog contains information about changes
to packaging and when new code is pulled in (often at releaase time)
 - version strings usually end with a -\d (1.2.3-1, etc), so that you
can rev packaging (to say version 1.2.3-2) without changing the
upstream software/version string.

Some of these differences are because the upstream and packaging trees
are merged; that is probably not the usual setup.

Also, are you planning to try getting these pushed upstream into debian?
thanks.
 -nld

On Thu, Feb 21, 2013 at 4:18 AM, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> The changes that were done:
>
> [1] A debian directory was added containing the
>     definitions and rules for Debian package building.
>
> [2] New format of change log (Debian style) was added
>     to the gen_chlog.sh (is activated by --debian arg)
>
> Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  Makefile.am                             |    9 +-
>  debian/changelog                        |    5 +
>  debian/compat                           |    1 +
>  debian/control                          |   30 +++
>  debian/copyright                        |  376 +++++++++++++++++++++++++++++++
>  debian/docs                             |    3 +
>  debian/infiniband-diags-compat.install  |   19 ++
>  debian/infiniband-diags-compat.manpages |   16 ++
>  debian/infiniband-diags-guest.install   |    2 +
>  debian/infiniband-diags-guest.manpages  |    2 +
>  debian/infiniband-diags.install         |   35 +++
>  debian/infiniband-diags.manpages        |   33 +++
>  debian/rules                            |   32 +++
>  debian/source/format                    |    1 +
>  gen_chlog.sh                            |   65 +++++-
>  15 files changed, 622 insertions(+), 7 deletions(-)
>  create mode 100644 debian/changelog
>  create mode 100644 debian/compat
>  create mode 100644 debian/control
>  create mode 100644 debian/copyright
>  create mode 100644 debian/docs
>  create mode 100644 debian/infiniband-diags-compat.install
>  create mode 100644 debian/infiniband-diags-compat.manpages
>  create mode 100644 debian/infiniband-diags-guest.install
>  create mode 100644 debian/infiniband-diags-guest.manpages
>  create mode 100644 debian/infiniband-diags.install
>  create mode 100644 debian/infiniband-diags.manpages
>  create mode 100755 debian/rules
>  create mode 100644 debian/source/format
>
> diff --git a/Makefile.am b/Makefile.am
> index f44b4d6..cfe2b30 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -140,7 +140,13 @@ TESTS = tests/check_shells.sh
>  endif
>
>  EXTRA_DIST = doc scripts include infiniband-diags.spec.in infiniband-diags.spec \
> -       $(man_MANS) $(compat_man_pages) autogen.sh etc/*
> +            debian/changelog debian/compat debian/control debian/copyright \
> +            debian/docs debian/infiniband-diags-compat.install \
> +            debian/infiniband-diags-compat.manpages \
> +            debian/infiniband-diags-guest.install debian/infiniband-diags-guest.manpages \
> +            debian/infiniband-diags.install debian/infiniband-diags.manpages \
> +            debian/rules debian/source/format \
> +            $(man_MANS) $(compat_man_pages) autogen.sh etc/*
>
>  distclean-local:
>         $(top_srcdir)/doc/generate clean
> @@ -148,6 +154,7 @@ distclean-local:
>  dist-hook:
>         if [ -x $(top_srcdir)/gen_chlog.sh ] ; then \
>                 $(top_srcdir)/gen_chlog.sh > $(distdir)/ChangeLog ; \
> +               $(top_srcdir)/gen_chlog.sh --debian > $(distdir)/debian/changelog ; \
>         fi
>
>  # install this to a default location.
> diff --git a/debian/changelog b/debian/changelog
> new file mode 100644
> index 0000000..487920f
> --- /dev/null
> +++ b/debian/changelog
> @@ -0,0 +1,5 @@
> +infiniband-diags (1.2.4.MLNX20070303.xxxxxxx) unstable; urgency=low
> +
> +  * Initial release.
> +
> + --  Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>  Thu, 03 Mar 2007 10:34:46 +0200
> diff --git a/debian/compat b/debian/compat
> new file mode 100644
> index 0000000..7f8f011
> --- /dev/null
> +++ b/debian/compat
> @@ -0,0 +1 @@
> +7
> diff --git a/debian/control b/debian/control
> new file mode 100644
> index 0000000..bc66838
> --- /dev/null
> +++ b/debian/control
> @@ -0,0 +1,30 @@
> +Source: infiniband-diags
> +Priority: net
> +Maintainer: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> +Build-Depends: debhelper (>= 8.0.0), autotools-dev, libopensm, libopensm-devel, libibumad-devel, libibmad-devel
> +Standards-Version: 1.6.1
> +Section: libs
> +Homepage: http://www.openfabrics.org/downloads/management/
> +
> +Package: infiniband-diags
> +Architecture: any
> +Depends: ${shlibs:Depends}, ${misc:Depends}
> +Description: OpenFabrics Alliance InfiniBand Diagnostic Tools
> + This package provides IB diagnostic programs and scripts needed to
> + diagnose an IB subnet.
> +
> +Package: infiniband-compat
> +Architecture:libs
> +Depends: ${shlibs:Depends}, ${misc:Depends}, libibmad-devel, opensm-devel, libibumad-devel
> +Description: OpenFabrics Alliance InfiniBand Diagnostic Tools
> + Deprecated scripts and utilities which provide duplicated functionality, most
> + often at a reduced performance.  These are maintained for the time being for
> + compatibility reasons.
> +
> +
> +Package: infiniband-guest
> +Architecture: libs
> +Depends: ${shlibs:Depends}, ${misc:Depends}
> +Description: OpenFabrics Alliance InfiniBand Diagnostic Tools for Guest OS
> + This package provides IB diagnostic programs and scripts for Virtual Machines,
> + needed to diagnose an IB subnet.
> diff --git a/debian/copyright b/debian/copyright
> new file mode 100644
> index 0000000..93c4b42
> --- /dev/null
> +++ b/debian/copyright
> @@ -0,0 +1,376 @@
> +Format: http://dep.debian.net/deps/dep5
> +Upstream-Name: libibumad
> +Maintainer: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> +Source: http://www.openfabrics.org/downloads/management
> +
> +Files: *
> +Copyright: 2010-2013 Mellanox Technologies LTD.
> +          2004-2009 Voltaire Inc.
> +License: OpenIB.org-BSD or GPLv2
> +
> +License: OpenIB.org-BSD
> + Redistribution and use in source and binary forms, with or without
> + modification, are permitted provided that the following conditions
> + are met:
> + .
> +   * Redistributions of source code must retain the above copyright
> +     notice, this list of conditions and the following disclaimer.
> + .
> +   * Redistributions in binary form must reproduce the above
> +     copyright notice, this list of conditions and the following
> +     disclaimer in the documentation and/or other materials provided
> +     with the distribution.
> + .
> + THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> + FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
> + COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
> + INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
> + BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> + LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
> + CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> + LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
> + ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> + POSSIBILITY OF SUCH DAMAGE.
> +
> +License: GPLv2
> +                     GNU GENERAL PUBLIC LICENSE
> +                        Version 2, June 1991
> + .
> +  Copyright (C) 1989, 1991 Free Software Foundation, Inc.
> +               59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> +  Everyone is permitted to copy and distribute verbatim copies
> +  of this license document, but changing it is not allowed.
> + .
> +                             Preamble
> + .
> +   The licenses for most software are designed to take away your
> + freedom to share and change it.  By contrast, the GNU General Public
> + License is intended to guarantee your freedom to share and change free
> + software--to make sure the software is free for all its users.  This
> + General Public License applies to most of the Free Software
> + Foundation's software and to any other program whose authors commit to
> + using it.  (Some other Free Software Foundation software is covered by
> + the GNU Library General Public License instead.)  You can apply it to
> + your programs, too.
> + .
> +   When we speak of free software, we are referring to freedom, not
> + price.  Our General Public Licenses are designed to make sure that you
> + have the freedom to distribute copies of free software (and charge for
> + this service if you wish), that you receive source code or can get it
> + if you want it, that you can change the software or use pieces of it
> + in new free programs; and that you know you can do these things.
> + .
> +   To protect your rights, we need to make restrictions that forbid
> + anyone to deny you these rights or to ask you to surrender the rights.
> + These restrictions translate to certain responsibilities for you if you
> + distribute copies of the software, or if you modify it.
> + .
> +   For example, if you distribute copies of such a program, whether
> + gratis or for a fee, you must give the recipients all the rights that
> + you have.  You must make sure that they, too, receive or can get the
> + source code.  And you must show them these terms so they know their
> + rights.
> + .
> +   We protect your rights with two steps: (1) copyright the software, and
> + (2) offer you this license which gives you legal permission to copy,
> + distribute and/or modify the software.
> + .
> +   Also, for each author's protection and ours, we want to make certain
> + that everyone understands that there is no warranty for this free
> + software.  If the software is modified by someone else and passed on, we
> + want its recipients to know that what they have is not the original, so
> + that any problems introduced by others will not reflect on the original
> + authors' reputations.
> + .
> +   Finally, any free program is threatened constantly by software
> + patents.  We wish to avoid the danger that redistributors of a free
> + program will individually obtain patent licenses, in effect making the
> + program proprietary.  To prevent this, we have made it clear that any
> + patent must be licensed for everyone's free use or not licensed at all.
> + .
> +   The precise terms and conditions for copying, distribution and
> + modification follow.
> + .
> +                     GNU GENERAL PUBLIC LICENSE
> +    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
> + .
> +   0. This License applies to any program or other work which contains
> + a notice placed by the copyright holder saying it may be distributed
> + under the terms of this General Public License.  The "Program", below,
> + refers to any such program or work, and a "work based on the Program"
> + means either the Program or any derivative work under copyright law:
> + that is to say, a work containing the Program or a portion of it,
> + either verbatim or with modifications and/or translated into another
> + language.  (Hereinafter, translation is included without limitation in
> + the term "modification".)  Each licensee is addressed as "you".
> + .
> + Activities other than copying, distribution and modification are not
> + covered by this License; they are outside its scope.  The act of
> + running the Program is not restricted, and the output from the Program
> + is covered only if its contents constitute a work based on the
> + Program (independent of having been made by running the Program).
> + Whether that is true depends on what the Program does.
> + .
> +   1. You may copy and distribute verbatim copies of the Program's
> + source code as you receive it, in any medium, provided that you
> + conspicuously and appropriately publish on each copy an appropriate
> + copyright notice and disclaimer of warranty; keep intact all the
> + notices that refer to this License and to the absence of any warranty;
> + and give any other recipients of the Program a copy of this License
> + along with the Program.
> + .
> + You may charge a fee for the physical act of transferring a copy, and
> + you may at your option offer warranty protection in exchange for a fee.
> + .
> +   2. You may modify your copy or copies of the Program or any portion
> + of it, thus forming a work based on the Program, and copy and
> + distribute such modifications or work under the terms of Section 1
> + above, provided that you also meet all of these conditions:
> + .
> +     a) You must cause the modified files to carry prominent notices
> +     stating that you changed the files and the date of any change.
> + .
> +     b) You must cause any work that you distribute or publish, that in
> +     whole or in part contains or is derived from the Program or any
> +     part thereof, to be licensed as a whole at no charge to all third
> +     parties under the terms of this License.
> + .
> +     c) If the modified program normally reads commands interactively
> +     when run, you must cause it, when started running for such
> +     interactive use in the most ordinary way, to print or display an
> +     announcement including an appropriate copyright notice and a
> +     notice that there is no warranty (or else, saying that you provide
> +     a warranty) and that users may redistribute the program under
> +     these conditions, and telling the user how to view a copy of this
> +     License.  (Exception: if the Program itself is interactive but
> +     does not normally print such an announcement, your work based on
> +     the Program is not required to print an announcement.)
> + .
> + These requirements apply to the modified work as a whole.  If
> + identifiable sections of that work are not derived from the Program,
> + and can be reasonably considered independent and separate works in
> + themselves, then this License, and its terms, do not apply to those
> + sections when you distribute them as separate works.  But when you
> + distribute the same sections as part of a whole which is a work based
> + on the Program, the distribution of the whole must be on the terms of
> + this License, whose permissions for other licensees extend to the
> + entire whole, and thus to each and every part regardless of who wrote it.
> + .
> + Thus, it is not the intent of this section to claim rights or contest
> + your rights to work written entirely by you; rather, the intent is to
> + exercise the right to control the distribution of derivative or
> + collective works based on the Program.
> + .
> + In addition, mere aggregation of another work not based on the Program
> + with the Program (or with a work based on the Program) on a volume of
> + a storage or distribution medium does not bring the other work under
> + the scope of this License.
> + .
> +   3. You may copy and distribute the Program (or a work based on it,
> + under Section 2) in object code or executable form under the terms of
> + Sections 1 and 2 above provided that you also do one of the following:
> + .
> +     a) Accompany it with the complete corresponding machine-readable
> +     source code, which must be distributed under the terms of Sections
> +     1 and 2 above on a medium customarily used for software interchange; or,
> + .
> +     b) Accompany it with a written offer, valid for at least three
> +     years, to give any third party, for a charge no more than your
> +     cost of physically performing source distribution, a complete
> +     machine-readable copy of the corresponding source code, to be
> +     distributed under the terms of Sections 1 and 2 above on a medium
> +     customarily used for software interchange; or,
> + .
> +     c) Accompany it with the information you received as to the offer
> +     to distribute corresponding source code.  (This alternative is
> +     allowed only for noncommercial distribution and only if you
> +     received the program in object code or executable form with such
> +     an offer, in accord with Subsection b above.)
> + .
> + The source code for a work means the preferred form of the work for
> + making modifications to it.  For an executable work, complete source
> + code means all the source code for all modules it contains, plus any
> + associated interface definition files, plus the scripts used to
> + control compilation and installation of the executable.  However, as a
> + special exception, the source code distributed need not include
> + anything that is normally distributed (in either source or binary
> + form) with the major components (compiler, kernel, and so on) of the
> + operating system on which the executable runs, unless that component
> + itself accompanies the executable.
> + .
> + If distribution of executable or object code is made by offering
> + access to copy from a designated place, then offering equivalent
> + access to copy the source code from the same place counts as
> + distribution of the source code, even though third parties are not
> + compelled to copy the source along with the object code.
> + .
> +   4. You may not copy, modify, sublicense, or distribute the Program
> + except as expressly provided under this License.  Any attempt
> + otherwise to copy, modify, sublicense or distribute the Program is
> + void, and will automatically terminate your rights under this License.
> + However, parties who have received copies, or rights, from you under
> + this License will not have their licenses terminated so long as such
> + parties remain in full compliance.
> + .
> +   5. You are not required to accept this License, since you have not
> + signed it.  However, nothing else grants you permission to modify or
> + distribute the Program or its derivative works.  These actions are
> + prohibited by law if you do not accept this License.  Therefore, by
> + modifying or distributing the Program (or any work based on the
> + Program), you indicate your acceptance of this License to do so, and
> + all its terms and conditions for copying, distributing or modifying
> + the Program or works based on it.
> + .
> +   6. Each time you redistribute the Program (or any work based on the
> + Program), the recipient automatically receives a license from the
> + original licensor to copy, distribute or modify the Program subject to
> + these terms and conditions.  You may not impose any further
> + restrictions on the recipients' exercise of the rights granted herein.
> + You are not responsible for enforcing compliance by third parties to
> + this License.
> + .
> +   7. If, as a consequence of a court judgment or allegation of patent
> + infringement or for any other reason (not limited to patent issues),
> + conditions are imposed on you (whether by court order, agreement or
> + otherwise) that contradict the conditions of this License, they do not
> + excuse you from the conditions of this License.  If you cannot
> + distribute so as to satisfy simultaneously your obligations under this
> + License and any other pertinent obligations, then as a consequence you
> + may not distribute the Program at all.  For example, if a patent
> + license would not permit royalty-free redistribution of the Program by
> + all those who receive copies directly or indirectly through you, then
> + the only way you could satisfy both it and this License would be to
> + refrain entirely from distribution of the Program.
> + .
> + If any portion of this section is held invalid or unenforceable under
> + any particular circumstance, the balance of the section is intended to
> + apply and the section as a whole is intended to apply in other
> + circumstances.
> + .
> + It is not the purpose of this section to induce you to infringe any
> + patents or other property right claims or to contest validity of any
> + such claims; this section has the sole purpose of protecting the
> + integrity of the free software distribution system, which is
> + implemented by public license practices.  Many people have made
> + generous contributions to the wide range of software distributed
> + through that system in reliance on consistent application of that
> + system; it is up to the author/donor to decide if he or she is willing
> + to distribute software through any other system and a licensee cannot
> + impose that choice.
> + .
> + This section is intended to make thoroughly clear what is believed to
> + be a consequence of the rest of this License.
> + .
> +   8. If the distribution and/or use of the Program is restricted in
> + certain countries either by patents or by copyrighted interfaces, the
> + original copyright holder who places the Program under this License
> + may add an explicit geographical distribution limitation excluding
> + those countries, so that distribution is permitted only in or among
> + countries not thus excluded.  In such case, this License incorporates
> + the limitation as if written in the body of this License.
> + .
> +   9. The Free Software Foundation may publish revised and/or new versions
> + of the General Public License from time to time.  Such new versions will
> + be similar in spirit to the present version, but may differ in detail to
> + address new problems or concerns.
> + .
> + Each version is given a distinguishing version number.  If the Program
> + specifies a version number of this License which applies to it and "any
> + later version", you have the option of following the terms and conditions
> + either of that version or of any later version published by the Free
> + Software Foundation.  If the Program does not specify a version number of
> + this License, you may choose any version ever published by the Free Software
> + Foundation.
> + .
> +   10. If you wish to incorporate parts of the Program into other free
> + programs whose distribution conditions are different, write to the author
> + to ask for permission.  For software which is copyrighted by the Free
> + Software Foundation, write to the Free Software Foundation; we sometimes
> + make exceptions for this.  Our decision will be guided by the two goals
> + of preserving the free status of all derivatives of our free software and
> + of promoting the sharing and reuse of software generally.
> + .
> +                             NO WARRANTY
> + .
> +   11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
> + FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
> + OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
> + PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
> + OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> + MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
> + TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
> + PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
> + REPAIR OR CORRECTION.
> + .
> +   12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
> + WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
> + REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
> + INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
> + OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
> + TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
> + YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
> + PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
> + POSSIBILITY OF SUCH DAMAGES.
> + .
> +                      END OF TERMS AND CONDITIONS
> + .
> +             How to Apply These Terms to Your New Programs
> + .
> +   If you develop a new program, and you want it to be of the greatest
> + possible use to the public, the best way to achieve this is to make it
> + free software which everyone can redistribute and change under these terms.
> + .
> +   To do so, attach the following notices to the program.  It is safest
> + to attach them to the start of each source file to most effectively
> + convey the exclusion of warranty; and each file should have at least
> + the "copyright" line and a pointer to where the full notice is found.
> + .
> +     <one line to give the program's name and a brief idea of what it does.>
> +     Copyright (C) <year>  <name of author>
> + .
> +     This program is free software; you can redistribute it and/or modify
> +     it under the terms of the GNU General Public License as published by
> +     the Free Software Foundation; either version 2 of the License, or
> +     (at your option) any later version.
> + .
> +     This program is distributed in the hope that it will be useful,
> +     but WITHOUT ANY WARRANTY; without even the implied warranty of
> +     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +     GNU General Public License for more details.
> + .
> +     You should have received a copy of the GNU General Public License
> +     along with this program; if not, write to the Free Software
> +     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + .
> + Also add information on how to contact you by electronic and paper mail.
> + .
> + If the program is interactive, make it output a short notice like this
> + when it starts in an interactive mode:
> + .
> +     Gnomovision version 69, Copyright (C) year name of author
> +     Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
> +     This is free software, and you are welcome to redistribute it
> +     under certain conditions; type `show c' for details.
> + .
> + The hypothetical commands `show w' and `show c' should show the appropriate
> + parts of the General Public License.  Of course, the commands you use may
> + be called something other than `show w' and `show c'; they could even be
> + mouse-clicks or menu items--whatever suits your program.
> + .
> + You should also get your employer (if you work as a programmer) or your
> + school, if any, to sign a "copyright disclaimer" for the program, if
> + necessary.  Here is a sample; alter the names:
> + .
> +   Yoyodyne, Inc., hereby disclaims all copyright interest in the program
> +   `Gnomovision' (which makes passes at compilers) written by James Hacker.
> + .
> +   <signature of Ty Coon>, 1 April 1989
> +   Ty Coon, President of Vice
> + .
> + This General Public License does not permit incorporating your program into
> + proprietary programs.  If your program is a subroutine library, you may
> + consider it more useful to permit linking proprietary applications with the
> + library.  If this is what you want to do, use the GNU Library General
> + Public License instead of this License.
> diff --git a/debian/docs b/debian/docs
> new file mode 100644
> index 0000000..c4412c8
> --- /dev/null
> +++ b/debian/docs
> @@ -0,0 +1,3 @@
> +README
> +debian/copyright
> +debian/changelog
> diff --git a/debian/infiniband-diags-compat.install b/debian/infiniband-diags-compat.install
> new file mode 100644
> index 0000000..074db67
> --- /dev/null
> +++ b/debian/infiniband-diags-compat.install
> @@ -0,0 +1,19 @@
> +usr/sbin/ibcheckerrs
> +usr/sbin/ibchecknet
> +usr/sbin/ibchecknode
> +usr/sbin/ibcheckport
> +usr/sbin/ibcheckportwidth
> +usr/sbin/ibcheckportstate
> +usr/sbin/ibcheckwidth
> +usr/sbin/ibcheckstate
> +usr/sbin/ibcheckerrors
> +usr/sbin/ibdatacounts
> +usr/sbin/ibdatacounters
> +usr/sbin/ibdiscover.pl
> +usr/sbin/ibswportwatch.pl
> +usr/sbin/ibqueryerrors.pl
> +usr/sbin/iblinkinfo.pl
> +usr/sbin/ibprintca.pl
> +usr/sbin/ibprintswitch.pl
> +usr/sbin/ibprintrt.pl
> +usr/sbin/set_nodedesc.sh
> diff --git a/debian/infiniband-diags-compat.manpages b/debian/infiniband-diags-compat.manpages
> new file mode 100644
> index 0000000..9d756fa
> --- /dev/null
> +++ b/debian/infiniband-diags-compat.manpages
> @@ -0,0 +1,16 @@
> +usr/share/man/man8/ibcheckerrs.*
> +usr/share/man/man8/ibchecknet.*
> +usr/share/man/man8/ibchecknode.*
> +usr/share/man/man8/ibcheckport.*
> +usr/share/man/man8/ibcheckportwidth.*
> +usr/share/man/man8/ibcheckportstate.*
> +usr/share/man/man8/ibcheckwidth.*
> +usr/share/man/man8/ibcheckstate.*
> +usr/share/man/man8/ibcheckerrors.*
> +usr/share/man/man8/ibdatacounts.*
> +usr/share/man/man8/ibdatacounters.*
> +usr/share/man/man8/ibdiscover.*
> +usr/share/man/man8/ibswportwatch.*
> +usr/share/man/man8/ibprintca.*
> +usr/share/man/man8/ibprintswitch.*
> +usr/share/man/man8/ibprintrt.*
> diff --git a/debian/infiniband-diags-guest.install b/debian/infiniband-diags-guest.install
> new file mode 100644
> index 0000000..046bd3f
> --- /dev/null
> +++ b/debian/infiniband-diags-guest.install
> @@ -0,0 +1,2 @@
> +usr/sbin/ibstat
> +usr/sbin/ibstatus
> diff --git a/debian/infiniband-diags-guest.manpages b/debian/infiniband-diags-guest.manpages
> new file mode 100644
> index 0000000..b6f5986
> --- /dev/null
> +++ b/debian/infiniband-diags-guest.manpages
> @@ -0,0 +1,2 @@
> +usr/share/man/man8/ibstat.8*
> +usr/share/man/man8/ibstatus.8*
> diff --git a/debian/infiniband-diags.install b/debian/infiniband-diags.install
> new file mode 100644
> index 0000000..ec594d5
> --- /dev/null
> +++ b/debian/infiniband-diags.install
> @@ -0,0 +1,35 @@
> +usr/sbin/ibaddr
> +usr/sbin/ibnetdiscover
> +usr/sbin/ibping
> +usr/sbin/ibportstate
> +usr/sbin/ibroute
> +usr/sbin/ibstat
> +usr/sbin/ibsysstat
> +usr/sbin/ibtracert
> +usr/sbin/perfquery
> +usr/sbin/sminfo
> +usr/sbin/smpdump
> +usr/sbin/smpquery
> +usr/sbin/saquery
> +usr/sbin/vendstat
> +usr/sbin/iblinkinfo
> +usr/sbin/ibqueryerrors
> +usr/sbin/ibcacheedit
> +usr/sbin/ibccquery
> +usr/sbin/ibccconfig
> +usr/sbin/ibmirror
> +usr/sbin/ibhosts
> +usr/sbin/ibswitches
> +usr/sbin/ibnodes
> +usr/sbin/ibrouters
> +usr/sbin/ibfindnodesusing.pl
> +usr/sbin/ibidsverify.pl
> +usr/sbin/check_lft_balance.pl
> +usr/sbin/dump_lfts.sh
> +usr/sbin/dump_mfts.sh
> +usr/sbin/ibclearerrors
> +usr/sbin/ibclearcounters
> +usr/sbin/ibstatus
> +usr/lib/*.a
> +usr/lib/*.so*
> +usr/include/infiniband/*.h
> diff --git a/debian/infiniband-diags.manpages b/debian/infiniband-diags.manpages
> new file mode 100644
> index 0000000..d2d0d31
> --- /dev/null
> +++ b/debian/infiniband-diags.manpages
> @@ -0,0 +1,33 @@
> +usr/share/man/man8/ibaddr.*
> +usr/share/man/man8/ibnetdiscover.*
> +usr/share/man/man8/ibping.*
> +usr/share/man/man8/ibportstate.*
> +usr/share/man/man8/ibroute.*
> +usr/share/man/man8/ibstat.*
> +usr/share/man/man8/ibsysstat.*
> +usr/share/man/man8/ibtracert.*
> +usr/share/man/man8/perfquery.*
> +usr/share/man/man8/sminfo.*
> +usr/share/man/man8/smpdump.*
> +usr/share/man/man8/smpquery.*
> +usr/share/man/man8/saquery.*
> +usr/share/man/man8/vendstat.*
> +usr/share/man/man8/iblinkinfo.*
> +usr/share/man/man8/ibqueryerrors.*
> +usr/share/man/man8/ibcacheedit.*
> +usr/share/man/man8/ibccquery.*
> +usr/share/man/man8/ibccconfig.*
> +usr/share/man/man8/ibhosts.*
> +usr/share/man/man8/ibswitches.*
> +usr/share/man/man8/ibnodes.*
> +usr/share/man/man8/ibrouters.*
> +usr/share/man/man8/ibfindnodesusing.*
> +usr/share/man/man8/ibidsverify.*
> +usr/share/man/man8/check_lft_balance.*
> +usr/share/man/man8/dump_lfts.*
> +usr/share/man/man8/dump_mfts.*
> +usr/share/man/man8/ibclearerrors.*
> +usr/share/man/man8/ibclearcounters.*
> +usr/share/man/man8/ibstatus.*
> +usr/share/man/man8/infiniband-diags.*
> +usr/share/man/man3/*
> diff --git a/debian/rules b/debian/rules
> new file mode 100755
> index 0000000..6b33964
> --- /dev/null
> +++ b/debian/rules
> @@ -0,0 +1,32 @@
> +#!/usr/bin/make -f
> +# -*- makefile -*-
> +# Sample debian/rules that uses debhelper.
> +# This file was originally written by Joey Hess and Craig Small.
> +# As a special exception, when this file is copied by dh-make into a
> +# dh-make output file, you may use that output file without restriction.
> +# This special exception was added by Craig Small in version 0.37 of dh-make.
> +
> +# Uncomment this to turn on verbose mode.
> +#export DH_VERBOSE=1
> +
> +clean:
> +       dh_testdir
> +       dh_clean
> +
> +build:
> +       dh_testdir
> +       ./configure --prefix=/usr \
> +       --includedir=/usr/include \
> +       --mandir=/usr/share/man \
> +       --infodir=/usr/share/info \
> +       --sysconfdir=/etc \
> +       --localstatedir=/var \
> +       --libexecdir=/usr/lib/infiniband-diags \
> +       --disable-dependecy-tracking \
> +       --enable-compat-utils
> +       dh_auto_build
> +       dh_auto_test
> +
> +binary:
> +       dh $@
> +
> diff --git a/debian/source/format b/debian/source/format
> new file mode 100644
> index 0000000..89ae9db
> --- /dev/null
> +++ b/debian/source/format
> @@ -0,0 +1 @@
> +3.0 (native)
> diff --git a/gen_chlog.sh b/gen_chlog.sh
> index 34dfa24..dbd601d 100755
> --- a/gen_chlog.sh
> +++ b/gen_chlog.sh
> @@ -8,6 +8,8 @@ usage()
>
>  if [ "$1" = "--spec" ] ; then
>         spec_format=1
> +elif [ "$1" = "--debian" ] ; then
> +       debian_format=1
>  fi
>
>  GIT_DIR=`git rev-parse --git-dir 2>/dev/null`
> @@ -57,11 +59,62 @@ mkchlog()
>  }
>
>
> -if [ -z "$spec_format" ] ; then
> -       mkchlog --pretty=format:"%ad %an%n%H%n%n* %s%n" \
> -               | sed -e 's/^\* /\t* /'
> +# supports 2 different types of tags: x.x.x && infiniband-diags-x.x.x
> +# while the first type is the most recent that is used now
> +# and the second type is the previous one used
> +mkchlog_debian()
> +{
> +       package=`grep AC_INIT configure.in | cut -d"(" -f2 | cut -d"," -f1`
> +
> +       for tag in `git tag -l '*'` ; do
> +               pkg_name=`echo $tag | grep infiniband`
> +               if [ -z $pkg_name ] ; then
> +                       continue
> +               fi
> +               obj=`git show $tag | awk '/^commit /{print $2}'`
> +               base=`git merge-base $obj HEAD`
> +               if [ -z "$base" -o "$base" != $obj ] ; then
> +                       continue
> +               fi
> +               all_vers="$tag $all_vers"
> +       done
> +
> +       for tag in `git tag -l '*'` ; do
> +               pkg_name=`echo $tag | grep infiniband`
> +               if [ ! -z $pkg_name ] ; then
> +                       continue
> +               fi
> +               obj=`git show $tag | awk '/^commit /{print $2}'`
> +               base=`git merge-base $obj HEAD`
> +               if [ -z "$base" -o "$base" != $obj ] ; then
> +                       continue
> +               fi
> +               all_vers="$tag $all_vers"
> +       done
> +
> +       prev_ver="HEAD"
> +
> +       for ver in $all_vers ; do
> +               log_out=`git log "$ver..$prev_ver" -- ./`
> +               if [ -z "$log_out" ] ; then
> +                       continue
> +               fi
> +               ver_num=`echo $ver | cut -d"-" -f3`
> +               log_format="--pretty=format:${package} ($ver_num.MLNX%ai.%h) unstable; urgency=low%n%n  * %s%n%n --  %an <%ae>  %aD%n"
> +               git log --no-merges "${log_format}" "$ver..$prev_ver" -- ./
> +               prev_ver=$ver
> +       done
> +}
> +
> +if [ -z "$debian_format" ] ; then
> +       if [ -z "$spec_format" ] ; then
> +               mkchlog --pretty=format:"%ad %an%n%H%n%n* %s%n" \
> +                       | sed -e 's/^\* /\t* /'
> +       else
> +               echo "%changelog"
> +               mkchlog --pretty=format:"- %ad %an: %s"
> +               echo ""
> +       fi
>  else
> -       echo "%changelog"
> -       mkchlog --pretty=format:"- %ad %an: %s"
> -       echo ""
> +       mkchlog_debian | sed -e 's/\(MLNX\w\{4\}\)-\(\w\{2\}\)-\(\w\{2\}\) [0-9:]\{8\} [0-9+-]\{5\}/\1\2\3/'
>  fi
> --
> 1.7.9.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
