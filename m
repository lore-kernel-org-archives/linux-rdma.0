From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v10 00/11] uapi: export all headers under uapi directories
Date: Fri, 24 Mar 2017 09:32:54 +0100
Message-ID: <365519b5-d69e-34b7-fa2f-f11b8fabe69f@6wind.com>
References: <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
 <1489496093-15315-1-git-send-email-nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1489496093-15315-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: yamada.masahiro@socionext.com
Cc: arnd@arndb.de, mmarek@suse.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Le 14/03/2017 à 13:54, Nicolas Dichtel a écrit :
> Patches #1 and #2 are just cleanup: some exported headers were still under
> a non-uapi directory. Patch #3 is a fix to avoid exporting a file that was
> not under an uapi directory.
> After these three patches, all exported headers are under an uapi directory:
> path #4 stops searching files in non uapi directories.
> The patch #5 was spotted by code review: there is no in-tree user of this
> functionality.
> Patch #6 fixes some warnings/errors reported by 0-day tests.
> Patch #7 to #9 fix some errors when the corresponding files are included by
> userland.
> Patches #10 and #11 remove the need to list explicitly headers. Now all files
> under an uapi directory are exported.
> 
> This series has been tested with a 'make headers_install' on x86 and a
> 'make headers_install_all'. I've checked the result of both commands.
> 
> This patch is built on top of masahiroy/linux-kbuild.git#for-next (v4.11-rc1).
> I didn't find any conflict with v4.11-rc2.
Masahiro, is this series under review or do you expect something else on my side?


Regards,
Nicolas
