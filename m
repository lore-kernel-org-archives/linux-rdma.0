From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 0/5] ABI consistency check
Date: Tue, 14 Nov 2017 19:55:34 +0100
Message-ID: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add scripts to generate an ABI dump and compare against a ref.
Both tools (abi-dumper and abi-consistency-check) were imported as the
system version do not work on Travis.
Travis will automatically do that if a ref is present.
Ref should be added at stable-* branch creation (see doc update)

Nicolas Morey-Chaisemartin (5):
  buildlib: import abi checking tool
  buildlib: add script to dump ABI
  buildlib: add script to check ABI
  buildlib: run ABI check in travis-build
  Documentation: update stable doc about ABI reference generation

 Documentation/stable.md                            |    17 +
 buildlib/abi-checker/abi-compliance-checker.pl     | 10665 +++++++++++++++++++
 buildlib/abi-checker/abi-dumper.pl                 |  6793 ++++++++++++
 buildlib/abi-checker/modules/Internals/ABIDump.pm  |  1425 +++
 buildlib/abi-checker/modules/Internals/Basic.pm    |   744 ++
 buildlib/abi-checker/modules/Internals/CallConv.pm |  1352 +++
 .../abi-checker/modules/Internals/Descriptor.pm    |   289 +
 buildlib/abi-checker/modules/Internals/ElfTools.pm |   283 +
 buildlib/abi-checker/modules/Internals/Filter.pm   |   842 ++
 buildlib/abi-checker/modules/Internals/GccAst.pm   |  3907 +++++++
 buildlib/abi-checker/modules/Internals/Input.pm    |    32 +
 buildlib/abi-checker/modules/Internals/Logging.pm  |   172 +
 buildlib/abi-checker/modules/Internals/Mangling.pm |  1050 ++
 buildlib/abi-checker/modules/Internals/Path.pm     |    89 +
 buildlib/abi-checker/modules/Internals/RegTests.pm |  5199 +++++++++
 .../modules/Internals/Scripts/Sections.js          |    16 +
 .../abi-checker/modules/Internals/Scripts/Tabs.js  |    61 +
 .../modules/Internals/Styles/CmpSystems.css        |    84 +
 .../modules/Internals/Styles/HeadersDiff.css       |    49 +
 .../modules/Internals/Styles/Report.css            |   254 +
 .../modules/Internals/Styles/SymbolsList.css       |    79 +
 .../abi-checker/modules/Internals/Styles/Tabs.css  |    34 +
 buildlib/abi-checker/modules/Internals/SysCheck.pm |  2485 +++++
 buildlib/abi-checker/modules/Internals/SysFiles.pm |  2545 +++++
 buildlib/abi-checker/modules/Internals/TUDump.pm   |   969 ++
 buildlib/abi-checker/modules/Internals/TypeAttr.pm |   266 +
 buildlib/abi-checker/modules/Internals/Utils.pm    |   491 +
 buildlib/abi-checker/modules/Internals/XmlDump.pm  |   861 ++
 buildlib/abi-checker/modules/RulesBin.xml          |  3563 +++++++
 buildlib/abi-checker/modules/RulesSrc.xml          |  1792 ++++
 buildlib/gen-abi                                   |    18 +
 buildlib/travis-build                              |     4 +
 buildlib/travis-checkabi                           |    28 +
 33 files changed, 46458 insertions(+)
 create mode 100755 buildlib/abi-checker/abi-compliance-checker.pl
 create mode 100755 buildlib/abi-checker/abi-dumper.pl
 create mode 100644 buildlib/abi-checker/modules/Internals/ABIDump.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/Basic.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/CallConv.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/Descriptor.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/ElfTools.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/Filter.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/GccAst.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/Input.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/Logging.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/Mangling.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/Path.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/RegTests.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/Scripts/Sections.js
 create mode 100644 buildlib/abi-checker/modules/Internals/Scripts/Tabs.js
 create mode 100644 buildlib/abi-checker/modules/Internals/Styles/CmpSystems.css
 create mode 100644 buildlib/abi-checker/modules/Internals/Styles/HeadersDiff.css
 create mode 100644 buildlib/abi-checker/modules/Internals/Styles/Report.css
 create mode 100644 buildlib/abi-checker/modules/Internals/Styles/SymbolsList.css
 create mode 100644 buildlib/abi-checker/modules/Internals/Styles/Tabs.css
 create mode 100644 buildlib/abi-checker/modules/Internals/SysCheck.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/SysFiles.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/TUDump.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/TypeAttr.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/Utils.pm
 create mode 100644 buildlib/abi-checker/modules/Internals/XmlDump.pm
 create mode 100644 buildlib/abi-checker/modules/RulesBin.xml
 create mode 100644 buildlib/abi-checker/modules/RulesSrc.xml
 create mode 100755 buildlib/gen-abi
 create mode 100755 buildlib/travis-checkabi

-- 
2.15.0.168.g9a51f1b30.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
